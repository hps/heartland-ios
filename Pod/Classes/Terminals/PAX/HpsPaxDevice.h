#import <Foundation/Foundation.h>
#import "HpsDeviceProtocols.h"
#import "HpsConnectionConfig.h"
#import "HpsPaxHttpInterface.h"
#import "HpsTerminalEnums.h"
#import "HpsPaxInitializeResponse.h"
#import "HpsCommon.h"
#import "HpsPaxCreditResponse.h"
#import "HpsPaxDeviceResponse.h"
#import "HpsPaxDebitResponse.h"
#import "HpsPaxGiftResponse.h"
#import "HpsPaxBatchCloseResponse.h"
#import "HpsPaxLocalDetailResponse.h"
#import "HpaPaxSafUploadResponse.h"
#import "HpaPaxSafDeleteResponse.h"
#import "HpaPaxSafReportResponse.h"

@interface HpsPaxDevice : NSObject
{
    NSString *errorDomain;
}
@property (nonatomic, strong) HpsConnectionConfig *config;
@property (nonatomic, strong) id<IHPSDeviceCommInterface> interface;

- (id) initWithConfig:(HpsConnectionConfig*)config;

//Admin
- (void) initialize:(void(^)(HpsPaxInitializeResponse*, NSError*))responseBlock;
- (void) cancel:(void(^)(NSError*))responseBlock;
- (void) reset:(void(^)(HpsPaxDeviceResponse*, NSError*))responseBlock;
- (void) reboot:(void(^)(HpsPaxDeviceResponse*, NSError*))responseBlock;
- (void) setSafMode:(SafMode)safMode withResponseBlock:(void(^)(HpsPaxDeviceResponse*, NSError*))responseBlock;

//credit
- (void) doCredit:(NSString*)txnType
     andSubGroups:(NSArray*)subGroups
withResponseBlock:(void(^)(HpsPaxCreditResponse*, NSError*))responseBlock;

//Debt
- (void) doDebit:(NSString*)txnType
    andSubGroups:(NSArray*)subGroups
withResponseBlock:(void(^)(HpsPaxDebitResponse*, NSError*))responseBlock;


//gift
- (void) doGift:(NSString*)messageId
    withTxnType:(NSString*)txnType
   andSubGroups:(NSArray*)subGroups
withResponseBlock:(void(^)(HpsPaxGiftResponse*, NSError*))responseBlock;

//Report
- (void) doReport:(NSString*)edcType
     andSearchInput:(NSDictionary*)searchInputDict
     andSubGroups:(NSArray*)subGroups
withResponseBlock:(void(^)(HpsPaxLocalDetailResponse*, NSError*))responseBlock;

//batch
- (void) batchClose:(void(^)(HpsPaxBatchCloseResponse*, NSError*))responseBlock;
- (void) safUpload:(SafIndicator)safIndicator withResponseBlock:(void(^)(HpaPaxSafUploadResponse*, NSError*))responseBlock;
- (void) safDelete:(SafIndicator)safIndicator withResponseBlock:(void(^)(HpaPaxSafDeleteResponse*, NSError*))responseBlock;
- (void) safReport:(SafIndicator)safIndicator withResponseBlock:(void(^)(HpaPaxSafReportResponse*, NSError*))responseBlock;

@end
