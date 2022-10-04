#import "HpsConnectionConfig.h"
#import "Heartland_iOS_SDK-Swift.h"

@implementation HpsConnectionConfig

- (void)setLogger:(id<HpsInterfaceLogging>)logger {
    _logger = logger;
    [_logger willLogHPSInterfaceWithConfig:self];
}

@end
