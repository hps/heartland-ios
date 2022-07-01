#import "HpsUpaTcpInterface.h"
#import "HpsConnectionConfig.h"
#import "HpsTCPInterface.h"
#import "JsonDoc.h"

#define BUF_SIZE 8192

#pragma mark - Private properties and methods

@interface HpsUpaTcpInterface () <HpsTCPInterfaceDelegate>

@property (strong, nonatomic) HpsTCPInterface *interface;

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

- (void)send:(id<IHPSDeviceMessage>)message andResponseBlock:(void (^)(JsonDoc *, NSError *))responseBlock {    
}

// MARK: - HpsTCPInterfaceDelegate

- (void)tcpInterfaceDidCloseStreams {
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
