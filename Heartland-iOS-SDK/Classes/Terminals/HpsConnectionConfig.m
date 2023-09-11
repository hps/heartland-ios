#import "HpsConnectionConfig.h"
#if DEBUG
#import "Heartland_iOS_SDK/Heartland_iOS_SDK-Swift.h"
#else
#import <Heartland_iOS_SDK-Swift.h>
#endif

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
