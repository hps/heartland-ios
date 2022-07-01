#import <Foundation/Foundation.h>
#import "HpsDeviceProtocols.h"

@class HpsConnectionConfig;
@class JsonDoc;

@interface HpsUpaTcpInterface : NSObject <IHPSDeviceCommInterface>

- (instancetype)initWithConfig:(HpsConnectionConfig *)config;
- (void)send:(id<IHPSDeviceMessage>)message andResponseBlock:(void(^)(JsonDoc *, NSError *))responseBlock;

@end
