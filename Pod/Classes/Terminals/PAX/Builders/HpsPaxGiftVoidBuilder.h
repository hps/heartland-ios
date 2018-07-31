#import <Foundation/Foundation.h>
#import "HpsTransactionDetails.h"
#import "HpsPaxMessageIDs.h"
#import "HpsPaxDevice.h"
#import "HpsPaxAccountRequest.h"
#import "HpsPaxCashierSubGroup.h"
#import "HpsPaxAmountRequest.h"
#import "HpsPaxTraceRequest.h"
#import "HpsPaxExtDataSubGroup.h"
#import "HpsGiftCard.h"
#import "HpsPaxGiftResponse.h"

@interface HpsPaxGiftVoidBuilder : NSObject
{
    HpsPaxDevice *device;
}

@property (nonatomic, readwrite) int referenceNumber;
@property (nonatomic, readwrite) int transactionId;
@property (nonatomic) int currencyType;

- (void) execute:(void(^)(HpsPaxGiftResponse*, NSError*))responseBlock;
- (id)initWithDevice: (HpsPaxDevice*)paxDevice;

@end
