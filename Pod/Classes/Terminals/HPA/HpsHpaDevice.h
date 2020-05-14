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
#import "HpsHpaSafResponse.h"
#import "HpsHpaDiagnosticResponse.h"
#import "HpsHpaEodResponse.h"


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
- (void) GetLastResponse:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
- (void) setSAFMode:(BOOL)isSAF response:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
	// processTransaction
-(void)processTransactionWithRequest:(HpsHpaRequest*)HpsHpaRequest withResponseBlock:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
  //Get Diagnostic Report
- (void) getDiagnosticReport:(HpsHpaRequest*)HpsHpaRequest withResponseBlock:(void(^)(HpsHpaDiagnosticResponse*, NSError*))responseBlock;
  //SAF
-(void)processSAFWithRequest:(HpsHpaRequest*)HpsHpaRequest withResponseBlock:(void(^)(HpsHpaSafResponse*, NSError*))responseBlock;
  //EOD
-(void)processEODWithRequest:(HpsHpaRequest*)HpsHpaRequest withResponseBlock:(void(^)(HpsHpaEodResponse*, NSError*))responseBlock;
	//Random Number
-(int)generateNumber;

@end
