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

@interface HpsPaxGiftSaleBuilder : NSObject
{
    HpsPaxDevice *device;
}

@property (nonatomic, readwrite) int referenceNumber;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSNumber *gratuity;
@property (nonatomic, strong) HpsGiftCard *giftCard;
@property (nonatomic, strong) HpsTransactionDetails *details;
@property (nonatomic) int currencyType;
@property (nonatomic, readwrite) BOOL allowDuplicates;

- (void) execute:(void(^)(HpsPaxGiftResponse*, NSError*))responseBlock;
- (id)initWithDevice: (HpsPaxDevice*)paxDevice;

@end
