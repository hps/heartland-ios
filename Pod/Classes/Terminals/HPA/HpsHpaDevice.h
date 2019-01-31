#import <Foundation/Foundation.h>
#import "HpsDeviceProtocols.h"
#import "HpsConnectionConfig.h"
#import "HpsTerminalEnums.h"
#import "HpsCommon.h"
#import "HpaEnums.h"
#import "HpsHpaInitializeResponse.h"
#import "HpsHpaDeviceResponse.h"
#import "HpsHpaBatchResponse.h"
#import "HpsHpaRequest.h"

@interface HpsHpaDevice : NSObject<IDeviceInterface>
{
	NSString *errorDomain;
	MessageFormat format;

}
@property (nonatomic, strong) HpsConnectionConfig *config;
@property (nonatomic, strong) id<IHPSDeviceCommInterface> interface;

- (id) initWithConfig:(HpsConnectionConfig*)config;
	//Admin
- (void) cancel:(void(^)(id<IHPSDeviceResponse> payload))responseBlock;
- (void) closeLane:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
- (void) disableHostResponseBeep:(void(^)(id <IInitializeResponse>, NSError*))responseBlock;
- (void) initialize:(void(^)(id <IInitializeResponse>, NSError*))responseBlock;
- (void) openLane:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
- (void) reboot:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
- (void) reset:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
- (void) batchClose:(void(^)(id <IBatchCloseResponse> , NSError*))responseBlock;
	// processTransaction
-(void)processTransactionWithRequest:(HpsHpaRequest*)HpsHpaRequest withResponseBlock:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;

	//Random Number
-(int)generateNumber;

@end
