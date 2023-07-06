#import "HpsConnectionConfig.h"
#import <Heartland_iOS_SDK/Heartland_iOS_SDK-Swift.h>

@implementation HpsConnectionConfig

-(id)init {
     if (self = [super init])  {
         self.timeout = 500; //Seconds
     }
     return self;
}

- (void)setLogger:(id<HpsInterfaceLogging>)logger {
    _logger = logger;
    [_logger willLogHPSInterfaceWithConfig:self];
}

@end
