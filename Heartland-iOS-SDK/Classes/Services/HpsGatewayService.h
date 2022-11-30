#import <Foundation/Foundation.h>
#import "HpsTransaction.h"
#import "HpsGatewayData.h"

@class HpsServicesConfig;

@interface HpsGatewayService : NSObject

- (id) initWithConfig:(HpsServicesConfig *) config;
- (void) doTransaction:(HpsTransaction *)transaction withResponseBlock:(void(^)(HpsGatewayData*, NSError*))responseBlock;

@end
