//
//  HpsTcpInterface.m
//  Heartland-iOS-SDK
//
//  Created by Desimini, Wilson on 7/1/22.
//

#import "HpsTcpInterface.h"
#import "HpsConnectionConfig.h"

#define BUF_SIZE 8192

@interface HpsTcpInterface () <NSStreamDelegate>

@property (strong, nonatomic) NSInputStream *inputStream;
@property (strong, nonatomic) NSOutputStream *outputStream;
@property (nonatomic) NSUInteger readByteIndex;
@property (nonatomic) NSUInteger writeByteIndex;
@property (strong, nonatomic) NSMutableData *inputBuffer;
@property (strong, nonatomic) NSMutableData *outputBuffer;

@end

@implementation HpsTcpInterface

// MARK: - Open / Close

- (void)openConnection {
    if (_config == nil) return;
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                       (__bridge CFStringRef)_config.ipAddress,
                                       [_config.port intValue],
                                       &readStream,
                                       &writeStream);
    NSInputStream *inputStream = (__bridge_transfer NSInputStream *)readStream;
    NSOutputStream *outputStream = (__bridge_transfer NSOutputStream *)writeStream;
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
    [self setInputStream:inputStream];
    [self setOutputStream:outputStream];
}

- (void)closeConnection {
    NSMutableArray *streams = [NSMutableArray array];
    if (_inputStream) [streams addObject:_inputStream];
    if (_outputStream) [streams addObject:_outputStream];
    for (NSStream *stream in streams) {
        [stream close];
        [stream removeFromRunLoop:[NSRunLoop currentRunLoop]
                          forMode:NSDefaultRunLoopMode];
        [stream setDelegate:nil];
    }
    [self setInputStream:nil];
    [self setOutputStream:nil];
    [self resetInputBuffer];
    [self resetOutputBuffer];
    [_delegate tcpInterfaceDidCloseStreams];
}

// MARK: - Send

- (void)sendData:(NSData *)data {
    [self sendData:data onOpen:NO];
}

- (void)sendData:(NSData *)data onOpen:(BOOL)onOpen {
    _outputBuffer = _outputBuffer ?: [NSMutableData data];
    [_outputBuffer appendData:data];
    if (onOpen) {
        [self openConnection];
    } else {
        [self writeBytesToStream:_outputStream];
    }
}

- (void)resetInputBuffer {
    [self setReadByteIndex:0];
    [self setInputBuffer:nil];
}

- (void)resetOutputBuffer {
    [self setWriteByteIndex:0];
    [self setOutputBuffer:nil];
}

// MARK: - NSStreamDelegate

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch(eventCode) {
        case NSStreamEventHasBytesAvailable:
            [self readBytesOfStream:(NSInputStream *)aStream];
            break;
        case NSStreamEventErrorOccurred:
            [self readErrorOfStream:aStream];
            break;
        case NSStreamEventEndEncountered:
            [self closeConnection];
            break;
        case NSStreamEventHasSpaceAvailable:
            [self writeBytesToStream:(NSOutputStream *)aStream];
            break;
        case NSStreamEventNone:
            break;
        case NSStreamEventOpenCompleted:
            [_delegate tcpInterfaceDidOpenStream];
            break;
    }
}

- (void)readBytesOfStream:(NSInputStream *)stream {
    _inputBuffer = _inputBuffer ?: [NSMutableData data];
    uint8_t buf[BUF_SIZE];
    NSInteger len = [stream read:buf maxLength:BUF_SIZE];
    if (len > 0) {
        [_inputBuffer appendBytes:(const void *)buf length:len];
        _readByteIndex += len;
        [_delegate tcpInterfaceDidReadData:_inputBuffer];
    } else {
        [self readErrorOfStream:stream];
    }
}

- (void)readErrorOfStream:(NSStream *)stream {
    NSError *error = [stream streamError];
    [_delegate tcpInterfaceDidReceiveStreamError:error];
    [self closeConnection];
}

- (void)writeBytesToStream:(NSOutputStream *)stream {
    if (_outputBuffer == nil) return;
    uint8_t *bytes = (uint8_t *)[_outputBuffer mutableBytes];
    bytes += _writeByteIndex;
    NSUInteger dataLen = [_outputBuffer length];
    NSUInteger len = MIN(dataLen - _writeByteIndex, BUF_SIZE);
    len = [stream write:bytes maxLength:len];
    if (len == -1) {
        [self readErrorOfStream:stream];
    } else if (len < dataLen) {
        _writeByteIndex += len;
    } else {
        [_delegate tcpInterfaceDidWriteData];
    }
}

@end
