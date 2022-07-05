#import "HpsUpaTcpInterface.h"
#import "HpsCommon.h"
#import "HpsConnectionConfig.h"
#import "HpsTCPInterface.h"
#import "HpsUPAParser.h"
#import "HpsUPATCPEvent.h"
#import "HpsTerminalUtilities.h"
#import "HpsUpaRequest.h"
#import "JsonDoc.h"

#define BUF_SIZE 8192

#pragma mark - Private properties and methods

@interface HpsUpaTcpInterface () <HpsTCPInterfaceDelegate>

@property (strong, nonatomic) HpsTCPInterface *interface;
@property (strong, nonatomic) NSMutableArray<HpsUPATCPEvent *> *events;
@property (nonatomic) HpsUPAHandler handler;
@property (strong, nonatomic) NSError *handlerError;
@property (strong, nonatomic) NSString *handlerJSONString;

@end

@implementation HpsUpaTcpInterface

- (instancetype)initWithConfig:(HpsConnectionConfig *)config {
    self = [super init];
    if (self) {
        _events = [NSMutableArray array];
        _interface = [[HpsTCPInterface alloc] init];
        _interface.config = config;
        _interface.delegate = self;
    }
    return self;
}

// MARK: - IHPSDeviceCommInterface

- (void)connect {
}

- (void)disconnect {
}

- (void)send:(id<IHPSDeviceMessage>)message andResponseBlock:(HpsUPAHandler)responseBlock {
#warning param type conflict w IHPSDeviceCommInterface
    [self addEventsWithMessage:message];
    [self setHandler:responseBlock];
    NSData *data = [message getSendBuffer];
    [_interface sendData:data onOpen:YES];
}

// MARK: - HpsTCPInterfaceDelegate

- (void)tcpInterfaceDidCloseStreams {
    [_events removeAllObjects];
    NSString *jsonString = [_handlerJSONString copy];
    JsonDoc *json = jsonString ?
    [JsonDoc parse:jsonString] : nil;
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
        #warning tbd - store response obj here
        [self executeNextMessage];
    } else {
        [self errorOccurredInvalidMessage:data];
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
        [[HpsUPATCPEvent alloc] initWithMessageType:UPA_MSG_TYPE_MSG
                                           sendBody:message],
        [[HpsUPATCPEvent alloc] initWithMessageType:UPA_MSG_TYPE_ACK],
        [[HpsUPATCPEvent alloc] initWithMessageType:UPA_MSG_TYPE_MSG],
        [[HpsUPATCPEvent alloc] initWithMessageType:UPA_MSG_TYPE_ACK
                                           sendBody:[self ackSend]]
    ]];
}

- (void)errorOccurredInvalidMessage:(NSData *)data {
    NSString *domain = HpsCommon.sharedInstance.hpsErrorDomain;
    NSString *description = @"Invalid message received from UPA device.";
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: description};
    NSError *error = [NSError errorWithDomain:domain code:CocoaError userInfo:userInfo];
    [self setHandlerError:error];
}

- (void)executeNextMessage {
    [_events removeObjectAtIndex:0];
    HpsUPATCPEvent *nextEvent = [_events firstObject];
    if (nextEvent == nil) {
        [_interface closeConnection];
    } else if (nextEvent.sendBody) {
        [_interface sendData:[nextEvent.sendBody getSendBuffer]];
    }
}

- (BOOL)rawIsExpectedResponse:(NSData *)data {
    NSDictionary *json = [HpsUPAParser jsonfromUPARaw:data];
    NSString *receivedObj = [json objectForKey:@"message"];
    if (receivedObj == nil) return NO;
    UPA_MSG_TYPE received = [HpsUPAParser messageTypeFromUPARaw:receivedObj];
    return received == _events[0].messageType;
}

- (BOOL)rawIsPartialResponse:(NSData *)data {
    return ([HpsUPAParser dataFromUPARaw:data] != nil
            && [HpsUPAParser jsonfromUPARaw:data] == nil);
}

@end
