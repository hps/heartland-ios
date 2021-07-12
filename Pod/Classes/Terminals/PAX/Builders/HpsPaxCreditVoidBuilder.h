#import <Foundation/Foundation.h>
#import "HpsPaxMessageIDs.h"
#import "HpsPaxCreditResponse.h"
#import "HpsPaxAvsRequest.h"
#import "HpsPaxAccountRequest.h"
#import "HpsPaxCashierSubGroup.h"
#import "HpsPaxCommercialRequest.h"
#import "HpsPaxAmountRequest.h"
#import "HpsPaxTraceRequest.h"
#import "HpsPaxEcomSubGroup.h"
#import "HpsPaxExtDataSubGroup.h"
#import "HpsPaxDevice.h"

@interface HpsPaxCreditVoidBuilder : NSObject
{
    HpsPaxDevice *device;
}

@property (nonatomic, readwrite) NSInteger referenceNumber;
@property (nonatomic, readwrite) NSInteger transactionNumber;
@property (nonatomic, strong) NSString *transactionId;
@property (nonatomic, strong) NSString *clientTransactionId;

- (void) execute:(void(^)(HpsPaxCreditResponse*, NSError*))responseBlock;
- (id)initWithDevice: (HpsPaxDevice*)paxDevice;

@end
