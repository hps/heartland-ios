//  Copyright (c) 2017 Heartland Payment Systems. All rights reserved.

#import <Foundation/Foundation.h>
#import "HpsDeviceProtocols.h"
#import "HpsConnectionConfig.h"
#import "HpsTerminalEnums.h"
#import "HpsCommon.h"
#import "HeartSIPEnums.h"
#import "HpsHeartSipInitializeResponse.h"
#import "HpsHeartSipDeviceResponse.h"
#import "HpsHeartSipBatchResponse.h"
#import "HpsHeartSipRequest.h"

@interface HpsHeartSipDevice : NSObject<IDeviceInterface>
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
-(void)processTransactionWithRequest:(HpsHeartSipRequest*)HpsHeartSipRequest withResponseBlock:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;

@end
