#import <Foundation/Foundation.h>
#import "HpsDeviceProtocols.h"
#import "HpsConnectionConfig.h"

@interface HpsPaxHttpInterface : NSObject <IHPSDeviceCommInterface>

@property (nonatomic, strong) HpsConnectionConfig *config;

- (id) initWithConfig:(HpsConnectionConfig*)config;
-(void) connect;
-(void) disconnect;
-(void) send:(id<IHPSDeviceMessage>)message andResponseBlock:(void(^)(NSData*, NSError*))responseBlock;

@end
