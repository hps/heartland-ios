#import "HpsUpaTcpInterface.h"
#import "HpsCommon.h"
#import "HpsConnectionConfig.h"
#import "HpsTcpInterface.h"
#import "HpsUpaParser.h"
#import "HpsUpaEvent.h"
#import "HpsTerminalUtilities.h"
#import "HpsUpaRequest.h"
#import "JsonDoc.h"
#import "MBUPAErrorType.h"

#define BUF_SIZE 8192

#pragma mark - Private properties and methods

@interface HpsUpaTcpInterface () <HpsTcpInterfaceDelegate>

@property (strong, nonatomic) HpsTcpInterface *interface;
@property (strong, nonatomic) NSMutableArray<HpsUpaEvent *> *events;
@property (nonatomic) HpsUPAHandler handler;
@property (strong, nonatomic) NSError *handlerError;
@property (strong, nonatomic) NSString *handlerJSONString;

@end

@implementation HpsUpaTcpInterface

- (instancetype)initWithConfig:(HpsConnectionConfig *)config {
    self = [super init];
    if (self) {
        _events = [NSMutableArray array];
        _interface = [[HpsTcpInterface alloc] init];
        _interface.config = config;
        _interface.delegate = self;
    }
    return self;
}

// MARK: - IHPSDeviceCommInterface

- (void)connect {
}

- (void)disconnect {
    if (_handler == nil) return;
    [self errorOccurred:MBUPAErrorTypeConnectionForceClose];
    [_interface closeConnection];
}

- (void)send:(id<IHPSDeviceMessage>)message andResponseBlock:(void (^)(NSData *, NSError *))responseBlock {
    /// don't use this - all the response handling code within 'HpsUpaDevice'
    /// uses a conflicting block type, so we need to use the method below and
    /// list this method solely to conform to IHPSDeviceCommInterface.
    /// Need to rewrite this class to return a data object and populate this
    /// method if looking to use this object via a protocol-oriented dependency.
    responseBlock(nil, nil);
}

- (void)send:(id<IHPSDeviceMessage>)message andUPAResponseBlock:(HpsUPAHandler)responseBlock {
    [self addEventsWithMessage:message];
    [self setHandler:responseBlock];
    NSData *data = [message getSendBuffer];
    [_interface sendData:data onOpen:YES];
    
    __block HpsUpaTcpInterface *blocksafeSelf = self;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_interface.config.timeout * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if ([blocksafeSelf handler] != nil) {
                NSLog(@"HpsUpaTcpInterface timeout has reached.");
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Timeout"};
                self->_handler(nil, [NSError errorWithDomain: [HpsCommon sharedInstance].hpsErrorDomain
                                                        code: CocoaError
                                                    userInfo: userInfo]);
                [blocksafeSelf setHandler:nil];
                [[blocksafeSelf interface] closeConnection];
            }
        });
}

// MARK: - HpsTcpInterfaceDelegate

- (void)tcpInterfaceDidCloseStreams {
    [_events removeAllObjects];
    
    if (_handler == nil) return;
    
    BOOL closedEarly = _handlerJSONString == nil && _handlerError == nil;
    if (closedEarly) [self errorOccurred:MBUPAErrorTypeConnectionUnexpectedClose];
    NSString *jsonString = [_handlerJSONString copy];
    JsonDoc *json = jsonString ? [JsonDoc parse:jsonString] : nil;
    NSError *error = [_handlerError copy];
    [self setHandlerJSONString:nil];
    [self setHandlerError:nil];
    _handler(json, error);
    [self setHandler:nil];
}

- (void)tcpInterfaceDidOpenStream {
}

- (void)tcpInterfaceDidReadData:(NSData *)data {
    if ([self rawIsPartialResponse:data]) return;
    [_interface resetInputBuffer];
    if ([self rawIsExpectedResponse:data]) {
        [self storeResponseFromRaw:data];
        [self executeNextMessage];
    } else {
        if ([self rawIsBusyResponse:data]) {
            [self errorOccurred:MBUPAErrorTypeDeviceBusy];
        } else if ([self rawIsTimeoutResponse:data]) {
            [self errorOccurred:MBUPAErrorTypeDeviceTimeout];
        } else {
            [self errorOccurred:MBUPAErrorTypeCommunicationInvalidMessage];
        }
        [_interface closeConnection];
    }
}

- (void)tcpInterfaceDidReceiveStreamError:(NSError *)error {
    [self setHandlerError:error];
}

- (void)tcpInterfaceDidWriteData {
    [_interface resetOutputBuffer];
    [self executeNextMessage];
}

// MARK: - Utilities

- (id<IHPSDeviceMessage>)ackSend {
    HpsUpaRequest *request = [[HpsUpaRequest alloc] init];
    [request setMessage:@"ACK"];
    NSString *json = [request JSONString];
    return [HpsTerminalUtilities BuildRequest:json withFormat:UPA];
}

- (void)addEventsWithMessage:(id<IHPSDeviceMessage>)message {
    [_events addObjectsFromArray:@[
        [[HpsUpaEvent alloc] initWithMessageType:UPA_MSG_TYPE_MSG
                                        sendBody:message],
        [[HpsUpaEvent alloc] initWithMessageType:UPA_MSG_TYPE_ACK],
        [[HpsUpaEvent alloc] initWithMessageType:UPA_MSG_TYPE_MSG],
        [[HpsUpaEvent alloc] initWithMessageType:UPA_MSG_TYPE_ACK
                                        sendBody:[self ackSend]],
        [[HpsUpaEvent alloc] initWithMessageType:UPA_MSG_TYPE_READY]
    ]];
}

- (void)errorOccurred:(MBUPAErrorType)errorType {
    NSString *domain = HpsCommon.sharedInstance.hpsErrorDomain;
    NSString *description = [HpsUpaParser descriptionOfMBUPAErrorType:errorType];
    description = [NSString stringWithFormat:@"UPA response error - %@", description];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: description};
    NSError *error = [NSError errorWithDomain:domain code:errorType userInfo:userInfo];
    [self setHandlerError:error];
}

- (void)executeNextMessage {
    [_events removeObjectAtIndex:0];
    HpsUpaEvent *nextEvent = [_events firstObject];
    if (nextEvent == nil) {
        [_interface closeConnection];
    } else if (nextEvent.sendBody) {
        [_interface sendData:[nextEvent.sendBody getSendBuffer]];
    }
}

- (BOOL)isExpectingFinalMessage {
    HpsUpaEvent *expectedEvent = [_events firstObject];
    BOOL isReceipt = expectedEvent.sendBody == nil;
    return isReceipt && expectedEvent.messageType == UPA_MSG_TYPE_MSG;
}

- (BOOL)rawIsExpectedResponse:(NSData *)data {
    UPA_MSG_TYPE received = [HpsUpaParser messageTypeFromUPARaw:data];
    return received == _events[0].messageType;
}

- (BOOL)rawIsBusyResponse:(NSData *)data {
    return [HpsUpaParser messageTypeFromUPARaw:data] == UPA_MSG_TYPE_BUSY;
}

- (BOOL)rawIsTimeoutResponse:(NSData *)data {
    return [HpsUpaParser messageTypeFromUPARaw:data] == UPA_MSG_TYPE_TIMEOUT;
}

- (BOOL)rawIsPartialResponse:(NSData *)data {
    return ([HpsUpaParser dataFromUPARaw:data] != nil
            && [HpsUpaParser jsonfromUPARaw:data] == nil);
}

- (void)storeResponseFromRaw:(NSData *)data {
    if (![self isExpectingFinalMessage]) return;
    NSString *jsonString = [HpsUpaParser jsonStringFromUPARaw:data];
    [self setHandlerJSONString:jsonString];
}
@end
