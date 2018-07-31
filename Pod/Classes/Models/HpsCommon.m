#import "HpsCommon.h"

@implementation HpsCommon

static HpsCommon *_instance = nil;

+(HpsCommon *)sharedInstance
{
    @synchronized(self)
    {
        if(_instance == nil)
        {
            _instance = [HpsCommon new];
            _instance.hpsErrorDomain = @"com.heartlandpaymentsystems.iossdk";
        }
    }
    return _instance;
}

@end
