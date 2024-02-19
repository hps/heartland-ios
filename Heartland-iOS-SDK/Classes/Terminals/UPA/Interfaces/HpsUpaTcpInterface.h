#import <Foundation/Foundation.h>
#import "HpsDeviceProtocols.h"

@class HpsConnectionConfig;
@class JsonDoc;

typedef void (^HpsUPAHandler)(JsonDoc *, NSError *);

@interface HpsUpaTcpInterface : NSObject <IHPSDeviceCommInterface>

- (instancetype)initWithConfig:(HpsConnectionConfig *)config;

- (void)send:(id<IHPSDeviceMessage>)message andUPAResponseBlock:(HpsUPAHandler)responseBlock;
@end
