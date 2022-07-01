#import "HpsUpaTcpInterface.h"
#import "HpsConnectionConfig.h"
#import "HpsTCPInterface.h"
#import "JsonDoc.h"

#define BUF_SIZE 8192

#pragma mark - Private properties and methods

@interface HpsUpaTcpInterface () <HpsTCPInterfaceDelegate>

@property (strong, nonatomic) HpsTCPInterface *interface;
@property (nonatomic) NSInteger sequenceIndex;
@property (nonatomic) HpsUPAHandler handler;
@property (strong, nonatomic) NSError *handlerError;
@property (strong, nonatomic) NSString *handlerJSONString;

@end

@implementation HpsUpaTcpInterface

- (instancetype)initWithConfig:(HpsConnectionConfig *)config {
    self = [super init];
    if (self) {
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
    [self setSequenceIndex:0];
    [self setHandler:responseBlock];
    NSData *data = [message getSendBuffer];
    [_interface sendData:data onOpen:YES];
}

// MARK: - HpsTCPInterfaceDelegate

- (void)tcpInterfaceDidCloseStreams {
    [self setSequenceIndex:-1];
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
}

- (void)tcpInterfaceDidReceiveStreamError:(NSError *)error {
}

- (void)tcpInterfaceDidWriteData {
}

@end
