//
//  HpsCommon.m
//  Pods
//
//  Created by Shaunti Fondrisi on 2/16/16.
//
//

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
