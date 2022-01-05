#import "HpsUpaTcpInterface.h"
#import "HpsUpaDevice.h"
#import "HpsCommon.h"
#import "HpsterminalUtilities.h"
#import "NSObject+ObjectMap.h"
#import "NSInputStream+Hps.h"
#define BUF_SIZE 1024

#pragma mark - Private properties and methods

@interface HpsUpaTcpInterface () {
    NSString *errorDomain;
    NSString *filepath;
    int fileNumber;
    BOOL isHalfResponse;
}

- (BOOL)openConnection;
- (void)closeConnection;
- (BOOL)isConnected;
- (void)finishOpeningConnection;
- (void)readFromStreamToInputBuffer;
- (void)parseIncomingData;
- (void)writeOutputBufferToStream;
- (void)notifyConnectionBlock:(UpaConnectionBlock)block;

@end


@implementation HpsUpaTcpInterface

@synthesize messageReceivedBlock;
@synthesize connectionOpenedBlock, connectionFailedBlock, connectionClosedBlock;
@synthesize sendResponseBlock;

#pragma mark - Initializer

- (instancetype) initWithConfig:(HpsConnectionConfig*)config
{
    if((self = [super init]))
        {
        _config = config;
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

- (void)disconnect {
    [self closeConnection];
}


-(void) send:(id<IHPSDeviceMessage>)message andResponseBlock:(void(^)(JsonDoc*, NSError*))responseBlock
{
    [self openConnection];

    NSLog(@"request_toString = %@",message.toString);

    self.sendResponseBlock = responseBlock;
    [self addCallBackBlocks];
    [self connectionOpenBlock:message];

}

#pragma mark CallBack Methods

-(void) connectionOpenBlock:(id<IHPSDeviceMessage>)message{
        //Connection_open_block_start

    __weak typeof(self) weakSelf = self;
    __weak typeof(outputBuffer) weakOutputBuffer = outputBuffer;
    self.connectionOpenedBlock = ^(HpsUpaTcpInterface* connection){

        if([weakSelf isConnected]){

            NSData *data = [message getSendBuffer];
            [weakOutputBuffer appendBytes:data.bytes length:data.length];
            [weakSelf writeOutputBufferToStream];
        };
            // Connection_open_block_end
    };
}

-(void) messagesRecivedBlock{
        // Message_Recieve_block_start

    __weak typeof(self) weakSelf = self;
    __weak typeof(errorDomain) weakErrorDomain = errorDomain;

    self.messageReceivedBlock = ^(JsonDoc* upaObject, NSString* error){

        if (upaObject){

            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Step 3 without Error");

                weakSelf.sendResponseBlock(upaObject, nil);
                [weakSelf closeConnection];

            });

        }
        else{

            dispatch_async(dispatch_get_main_queue(), ^{

                NSDictionary *userInfo = @{NSLocalizedDescriptionKey:error};

                NSError *error = [NSError errorWithDomain:weakErrorDomain
                                                     code:CocoaError
                                                 userInfo:userInfo];
                NSLog(@"Step 3 with Error");

                weakSelf.sendResponseBlock(nil, error);
            });
        }
    };

        // Message_Recieve_block_end
}

-(void)connectionsClosedBlock{


        // Connection_Close_block_start

    self.connectionClosedBlock = ^(HpsUpaTcpInterface* connection){
        NSLog(@"connection closed");
    };
        // Connection_Close_block_end

}

-(void)connectionsFailedBlock
{
    __weak typeof(self) weakSelf = self;
    __weak typeof(errorDomain) weakErrorDomain = errorDomain;
        // Connection_Failed_Block_Start

    weakSelf.connectionFailedBlock = ^(HpsUpaTcpInterface* connection){
        dispatch_async(dispatch_get_main_queue(), ^{

            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:@"Connection Failed"};

            NSError *error = [NSError errorWithDomain:weakErrorDomain
                                                 code:CocoaError
                                             userInfo:userInfo];

            weakSelf.sendResponseBlock(nil, error);

        });
    };

        // Connection_Failed_Block_end

}
-(void) addCallBackBlocks
{
    [self connectionsClosedBlock];
    [self connectionsFailedBlock];
    [self messagesRecivedBlock];
}

#pragma mark - Private methods

- (BOOL)openConnection {
    isInputStreamOpen = NO;
    isOutputStreamOpen = NO;

    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;

    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                       (__bridge CFStringRef)self.config.ipAddress, self.config.port.intValue,
                                       &readStream, &writeStream);

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

    @try {
        [self getFullResponse:^(NSMutableData *response,NSInteger msgLength) {
            if (response){
                [self parseIncomingData];
            }
        }];

    } @catch (NSException *exception) {
        [self closeConnection];
        @throw exception;
    }
}

-(void)getFullResponse:(void(^)(NSMutableData *response,NSInteger msgLength))responseBlock{
    @synchronized (self) {
        NSMutableData *responseMutableData = [NSMutableData new];
        NSInteger response_length = BUF_SIZE;
        uint8_t buffer[response_length];

        NSInteger bytesReadlength = 0;
        NSInteger bytesReadlengthActual = 0;
        if ([inputStream hasBytesAvailable]) {
            fileNumber = fileNumber +1;

            do {
                memset(buffer, 0, sizeof(buffer));
                bytesReadlengthActual = [inputStream read:buffer maxLength:sizeof(buffer)];
                bytesReadlength += bytesReadlengthActual;

                
                [responseMutableData appendBytes:buffer length:bytesReadlengthActual];
            } while([inputStream hasBytesAvailable]);
        }

        BOOL readyReceived = false;

        if (bytesReadlength > 0) {
            NSLog(@"Total length= %ld",(long)bytesReadlength);
            
            NSString* bufferString = [[NSString alloc] initWithBytesNoCopy:[responseMutableData mutableBytes]
                                                                    length:[responseMutableData length]
                                                                  encoding:NSASCIIStringEncoding
                                                              freeWhenDone:NO];
            NSString* separator = [NSString stringWithFormat:@"%c%c%c%c%c", (char) HpsControlCodes_LF, (char) HpsControlCodes_ETX, (char) HpsControlCodes_LF, (char) HpsControlCodes_STX, (char) HpsControlCodes_LF];

            if ([bufferString containsString:separator]) {
                NSArray<NSString*>* parts = [bufferString componentsSeparatedByString:separator];
                bufferString = parts[1];
            }
            
            NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:separator];
            bufferString = [bufferString stringByTrimmingCharactersInSet:doNotWant];

            NSLog(@"received= %@",bufferString);
            
            JsonDoc* doc = [JsonDoc parse:bufferString];
            
            NSString* message = (NSString*)[doc getValue:@"message"];
            
            switch ([self messageType:message]) {
                case UPA_MSG_TYPE_UNKNOWN:
                case UPA_MSG_TYPE_ACK:
                case UPA_MSG_TYPE_NAK:
                    break;
                case UPA_MSG_TYPE_READY:
                    readyReceived = true;
                    break;
                case UPA_MSG_TYPE_BUSY:
                case UPA_MSG_TYPE_TIMEOUT:
                    break;
                case UPA_MSG_TYPE_MSG:
                case UPA_MSG_TYPE_DATA:
                    messageReceived = doc;
                    if ([self isNonReadyResponse:doc]) {
                        readyReceived = true;
                    }
                    [self sendAckMessageToDevice];
                    break;
            }
        }

        if (readyReceived == true) {
            responseBlock(responseMutableData,bytesReadlength);
        }
    }
}

-(BOOL) isNonReadyResponse:(JsonDoc*)doc {
    JsonDoc* data = [doc get:@"data"];
    if (data == nil) {
        return false;
    }
    JsonDoc* cmdResult = [data get:@"cmdResult"];
    return [(NSString*)[data getValue:@"response"] isEqualToString:UPA_MSG_ID_toString[UPA_MSG_ID_REBOOT]]
        || [(NSString*)[data getValue:@"response"] isEqualToString:@"Ping"]
        || (cmdResult != nil && [(NSString*)[cmdResult getValue:@"result"] isEqualToString:@"Failed"]);
}

-(void) sendAckMessageToDevice {
    HpsUpaRequest* request = [[HpsUpaRequest alloc] init];
    request.message = @"ACK";
    
    NSString* json = request.JSONString;
    
    NSLog(@"sent= %@",json);

    id<IHPSDeviceMessage> message = [HpsTerminalUtilities BuildRequest:json withFormat:UPA];

    __weak typeof(outputBuffer) weakOutputBuffer = outputBuffer;
    __weak typeof(self) weakSelf = self;
    NSData *data = [message getSendBuffer];
    [weakOutputBuffer appendBytes:data.bytes length:data.length];
    [weakSelf writeOutputBufferToStream];
}

- (UPA_MSG_TYPE) messageType:(NSString*)message {
    if ([message isEqualToString:@"ACK"]) {
        return UPA_MSG_TYPE_ACK;
    }
    if ([message isEqualToString:@"NAK"]) {
        return UPA_MSG_TYPE_NAK;
    }
    if ([message isEqualToString:@"READY"]) {
        return UPA_MSG_TYPE_READY;
    }
    if ([message isEqualToString:@"BUSY"]) {
        return UPA_MSG_TYPE_BUSY;
    }
    if ([message isEqualToString:@"TO"]) {
        return UPA_MSG_TYPE_TIMEOUT;
    }
    if ([message isEqualToString:@"MSG"]) {
        return UPA_MSG_TYPE_MSG;
    }
    if ([message isEqualToString:@"DATA"]) {
        return UPA_MSG_TYPE_DATA;
    }
    return UPA_MSG_TYPE_UNKNOWN;
}



- (void)parseIncomingData {

    @try {
        if (messageReceived != nil) {
            NSLog(@"\n\n **** No MultiMessage ...\n\n");
                //NSLog(@"TCP response FINAL = %@",[[NSString alloc]initWithData:inputBuffer encoding:NSASCIIStringEncoding] );

            if (messageReceivedBlock != nil) {
                messageReceivedBlock(messageReceived,nil);
            }

            [inputBuffer replaceBytesInRange:NSMakeRange(0,inputBuffer.length)
                                   withBytes:NULL
                                      length:0];
        }

    } @catch (NSException *exception) {
        @throw exception;
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

- (void)notifyConnectionBlock:(UpaConnectionBlock)block {
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
                @try {
                    [self readFromStreamToInputBuffer];

                } @catch (NSException *exception) {
                        //NSLog(@"stream = %@",exception);
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:exception.description};

                    NSError *error = [NSError errorWithDomain:errorDomain
                                                         code:CocoaError
                                                     userInfo:userInfo];

                    self.sendResponseBlock(nil, error);
                }
                break;

            case NSStreamEventHasSpaceAvailable:
                NSLog(@"#### SPACE AVAILABLE");
                break;

            case NSStreamEventErrorOccurred:

                [self closeConnection];

                break;
            case NSStreamEventEndEncountered:
                NSLog(@"#### End of Stream has been reached so now closing connection");

                if (messageReceivedBlock != nil)
                    messageReceivedBlock(messageReceived,nil);
                    //self.sendResponseBlock([server_message dataUsingEncoding:NSUTF8StringEncoding], nil);

                    //[self closeConnection];x
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
