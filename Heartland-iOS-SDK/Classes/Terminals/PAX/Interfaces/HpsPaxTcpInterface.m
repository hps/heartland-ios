#import "HpsPaxTcpInterface.h"
#import "HpsPaxDevice.h"
#import "HpsCommon.h"
#import "HpsterminalUtilities.h"

#pragma mark - Private properties and methods

@interface HpsPaxTcpInterface () {
    NSString *errorDomain;
    NSString *baseMessageString;
}

- (BOOL)openConnection;
- (void)closeConnection;
- (BOOL)isConnected;
- (void)finishOpeningConnection;
- (void)readFromStreamToInputBuffer;
- (void)parseIncomingData;
- (void)writeOutputBufferToStream;
- (void)notifyConnectionBlock:(ConnectionBlock)block;

@end

@implementation HpsPaxTcpInterface

@synthesize messageReceivedBlock;
@synthesize connectionOpenedBlock, connectionFailedBlock, connectionClosedBlock;
@synthesize sendResponseBlock;

#pragma mark - Initializer

- (instancetype) initWithConfig:(HpsConnectionConfig*)config
{
    if((self = [super init]))
    {
        self.config = config;
        errorDomain = [HpsCommon sharedInstance].hpsErrorDomain;
        
    }
    return self;
}

#pragma mark - IHPSDeviceCommInterface Required Methods

- (void)connect {
    if (![self isConnected]) {
        if (![self openConnection]) {
            [self notifyConnectionBlock:connectionFailedBlock];
        }
    }
}

- (NSString *)getPorForCancel {
    NSInteger portValue = [self.config.port integerValue] + 1;
    return [NSString stringWithFormat:@"%ld", (long)portValue];
}

- (void)disconnect {
    [self closeConnection];
}

-(void) send:(id<IHPSDeviceMessage>)message andResponseBlock:(void(^)(NSData*, NSError*))responseBlock
{
    baseMessageString = [message toString];
    [self openConnection];
    __weak typeof(self) weakSelf = self;
    __weak typeof(outputBuffer) weakOutputBuffer = outputBuffer;
    __weak typeof(errorDomain) weakErrorDomain = errorDomain;
    
    //Connection_open_block_start
    NSLog(@"request_toString = %@",message.toString);
    
    self.sendResponseBlock = responseBlock;
    
    self.connectionOpenedBlock = ^(HpsPaxTcpInterface* connection){
        
        if([weakSelf isConnected]){
            
            NSData *data = [message getSendBuffer];
            NSString *messageToSendOverTCP = [NSString stringWithUTF8String:[data bytes]];
            [weakOutputBuffer appendBytes:[messageToSendOverTCP cStringUsingEncoding:NSASCIIStringEncoding]
                                   length:[messageToSendOverTCP length]];
            
            [weakSelf writeOutputBufferToStream];
            
        };
        
        // Connection_open_block_end
        
        // Message_Recieve_block_start
        
        weakSelf.messageReceivedBlock = ^(HpsPaxTcpInterface* connection, NSString* server_message){
            
            NSLog(@"RECIEVED MESSAGE LENGTH = %ld",(unsigned long)server_message.length);
            if (server_message.length < 2) return ;
            
            if (connection){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    weakSelf.sendResponseBlock([server_message dataUsingEncoding:NSUTF8StringEncoding], nil);
                    
                    [weakSelf closeConnection];
                });
                
            }
            else
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:server_message};
                    
                    NSError *error = [NSError errorWithDomain:weakErrorDomain
                                                         code:CocoaError
                                                     userInfo:userInfo];
                    
                    responseBlock(nil, error);
                    
                });
            }
        };
        
        // Message_Recieve_block_end
        
        // Connection_Close_block_start
        
        weakSelf.connectionClosedBlock = ^(HpsPaxTcpInterface* connection){
            NSLog(@"connection closed");
        };
        // Connection_Close_block_end
        
        weakSelf.connectionFailedBlock = ^(HpsPaxTcpInterface* connection){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey:@"Connection Failed"};
                
                NSError *error = [NSError errorWithDomain:weakErrorDomain
                                                     code:CocoaError
                                                 userInfo:userInfo];
                
                responseBlock(nil, error);
                
            });
        };
        // Connection_Failed_Block_end
        
        
    };
}

#pragma mark - Private methods

- (BOOL)openConnection {
    isInputStreamOpen = NO;
    isOutputStreamOpen = NO;
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    if ([baseMessageString containsString:A14_CANCEL]) {
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           (__bridge CFStringRef)self.config.ipAddress,
                                           [[self getPorForCancel] intValue],
                                           &readStream, &writeStream);
    } else {
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           (__bridge CFStringRef)self.config.ipAddress, self.config.port.intValue,
                                           &readStream, &writeStream);
    }
    if (readStream == nil || writeStream == nil)
        return NO;
    
    CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket,
                            kCFBooleanTrue);
    CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket,
                             kCFBooleanTrue);
    
    inputStream = (__bridge_transfer NSInputStream*)readStream;
    inputStream.delegate = self;
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    
    outputStream = (__bridge_transfer NSOutputStream*)writeStream;
    outputStream.delegate = self;
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream open];
    
    inputBuffer = [[NSMutableData alloc] init];
    outputBuffer = [[NSMutableData alloc] init];
    
    return YES;
}

- (void)closeConnection {
    
    if (![self isConnected])
        [self notifyConnectionBlock:connectionFailedBlock];
    else
        [self notifyConnectionBlock:connectionClosedBlock];
    
    inputStream.delegate = nil;
    [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream close];
    inputStream = nil;
    isInputStreamOpen = NO;
    
    outputStream.delegate = nil;
    [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream close];
    outputStream = nil;
    isOutputStreamOpen = NO;
    
    inputBuffer = nil;
    outputBuffer = nil;
}

- (BOOL)isConnected {
    return (isInputStreamOpen && isOutputStreamOpen);
}

- (void)finishOpeningConnection {
    if (isInputStreamOpen && isOutputStreamOpen) {
        [self notifyConnectionBlock:connectionOpenedBlock];
        [self writeOutputBufferToStream];
    }
}

- (void)readFromStreamToInputBuffer {
    uint8_t buffer[1024];
    if ([inputStream hasBytesAvailable])
    {
        while ([inputStream hasBytesAvailable]) {
            NSInteger bytesRead = [inputStream read:buffer maxLength:sizeof(buffer)];
            [inputBuffer appendBytes:buffer length:bytesRead];
        }
        
        [self parseIncomingData];
        
    }
}

- (void)parseIncomingData {
    if ([inputBuffer length] > 0 ){
        
        if ([inputBuffer length] > 0) {
            NSString* bufferString = [[NSString alloc] initWithBytesNoCopy:[inputBuffer mutableBytes]
                                                                    length:[inputBuffer length]
                                                                  encoding:NSASCIIStringEncoding
                                                              freeWhenDone:NO];
            messageRecived = bufferString;
            if ([messageRecived length] == 1)
            {
                uint8_t * theBytes = [inputBuffer mutableBytes];
                
                NSLog(@"Reciving = %@ length = 1",[HpsTerminalEnums controlCodeAsciValue:(Byte)theBytes[0]]);
                
                
            }else
            {
                NSLog(@"Reciving = %@ ,length = %ld",messageRecived,(unsigned long)[messageRecived length]);
                
            }
            
            //			if (messageReceivedBlock != nil)
            //				messageReceivedBlock(self,messageRecived);
            
            [inputBuffer replaceBytesInRange:NSMakeRange(0,inputBuffer.length)
                                   withBytes:NULL
                                      length:0];
        }
        
    }
    else
    {
        uint8_t * theBytes = [inputBuffer mutableBytes];
        for (int i = 0 ; i < [inputBuffer length]; i++) {
            NSLog(@"InputBuffer blank ....can't process %02x",(Byte)theBytes[i]);
            
        }
        
        //messageReceivedBlock(nil,@"InputBuffer blank can't process");
    }
    
}

- (void)writeOutputBufferToStream {
    if (![self isConnected])
        return;
    
    if ([outputBuffer length] == 0)
        return;
    
    if (![outputStream hasSpaceAvailable])
        return;
    
    NSInteger bytesWritten = [outputStream write:[outputBuffer bytes]
                                       maxLength:[outputBuffer length]];
    
    if (bytesWritten == -1)  {
        [self disconnect];
        return;
    }
    
    [outputBuffer replaceBytesInRange:NSMakeRange(0, bytesWritten)
                            withBytes:NULL
                               length:0];
}

- (void)notifyConnectionBlock:(ConnectionBlock)block {
    if (block != nil)
        block(self);
}


#pragma mark - NSStreamDelegate methods

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)streamEvent {
    
    if (stream == inputStream) {
        switch (streamEvent) {
                
            case NSStreamEventOpenCompleted:
                isInputStreamOpen = YES;
                [self finishOpeningConnection];
                break;
                
            case NSStreamEventHasBytesAvailable:
                [self readFromStreamToInputBuffer];
                break;
                
            case NSStreamEventHasSpaceAvailable:
                break;
                
            case NSStreamEventErrorOccurred:
                messageReceivedBlock(nil,@"error occured -> InputStream");
                [self closeConnection];
                
                break;
            case NSStreamEventEndEncountered:
                NSLog(@"End of Stream has been reached so now closing connection");
                
                if (messageReceivedBlock != nil)
                    messageReceivedBlock(self,messageRecived);
                //self.sendResponseBlock([server_message dataUsingEncoding:NSUTF8StringEncoding], nil);
                
                //[self closeConnection];
                break;
            default:
                NSLog(@"Unknown Event Generated = %lu", (unsigned long)streamEvent);
                break;
        }
    }
    
    if (stream == outputStream) {
        switch (streamEvent) {
                
            case NSStreamEventOpenCompleted:
                isOutputStreamOpen = YES;
                [self finishOpeningConnection];
                break;
                
            case NSStreamEventHasBytesAvailable:
                break;
                
            case NSStreamEventHasSpaceAvailable:
                [self writeOutputBufferToStream];
                break;
                
            case NSStreamEventErrorOccurred:
                messageReceivedBlock(nil,@" Error Occured -> OutputStream");
                break;
            case NSStreamEventEndEncountered:
                [self closeConnection];
                break;
            default:
                NSLog(@"Unknown Event Generated = %lu", (unsigned long)streamEvent);
                break;
        }
    }
}

@end
