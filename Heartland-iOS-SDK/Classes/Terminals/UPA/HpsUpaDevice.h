#import <Foundation/Foundation.h>
#import "HpsDeviceProtocols.h"
#import "HpsConnectionConfig.h"
#import "HpsTerminalEnums.h"
#import "HpsCommon.h"
#import "UpaEnums.h"
#import "HpaEnums.h"
#import "HpsUpaTcpInterface.h"
#import "HpsUpaRequest.h"
#import "HpsUpaResponse.h"


@interface HpsUpaDevice : NSObject<IDeviceInterface>
{
    NSString *errorDomain;
    MessageFormat format;

}
@property (nonatomic, strong) HpsConnectionConfig *config;
@property (nonatomic, strong) HpsUpaTcpInterface *interface;

- (id) initWithConfig:(HpsConnectionConfig*)config;
    //Admin
- (void) cancel:(void(^)(id<IHPSDeviceResponse> payload))responseBlock;
- (void)cancelPendingNetworkRequest;
- (void) closeLane:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
- (void) disableHostResponseBeep:(void(^)(id <IInitializeResponse>, NSError*))responseBlock;
- (void) initialize:(void(^)(id <IInitializeResponse>, NSError*))responseBlock;
- (void) ping:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
- (void) openLane:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
- (void) reboot:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
- (void) reset:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
- (void) GetLastResponse:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
- (void) setSAFMode:(BOOL)isSAF response:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
    // processTransaction
-(void)processTransactionWithRequest:(HpsUpaRequest*)HpsUpaRequest withResponseBlock:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
-(void)processTransactionWithJSONString:(NSString*)HpsUpaRequestString withResponseBlock:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
//  //Get Diagnostic Report
- (void) getDiagnosticReport:(void(^)(HpsUpaResponse*, NSError*))responseBlock;
//  //SAF
//-(void)sendStoreAndForward:(void(^)(HpsUpaResponse*, NSError*))responseBlock;
//  //EOD
-(void)processEndOfDay:(void(^)(HpsUpaResponse*, NSError*))responseBlock;
    //Random Number
-(int)generateNumber;
- (void) lineItem:(NSString*)leftText withResponseBlock:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
- (void) lineItem:(NSString*)leftText withRightText:(NSString*)rightText withResponseBlock:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;

@end
