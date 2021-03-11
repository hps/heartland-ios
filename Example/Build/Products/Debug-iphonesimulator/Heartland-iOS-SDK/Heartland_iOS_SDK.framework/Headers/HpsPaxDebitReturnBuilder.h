#import <Foundation/Foundation.h>
#import "HpsPaxMessageIDs.h"
#import "HpsTransactionDetails.h"
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
#import "HpsPaxDebitResponse.h"

@interface HpsPaxDebitReturnBuilder : NSObject
{
    HpsPaxDevice *device;
}

@property (nonatomic, readwrite) int referenceNumber;
@property (nonatomic, readwrite) int transactionId;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *clientTransactionId;

- (void) execute:(void(^)(HpsPaxDebitResponse*, NSError*))responseBlock;
- (id)initWithDevice: (HpsPaxDevice*)paxDevice;

@end
