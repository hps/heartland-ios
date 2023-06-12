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

#import "HpsCreditCard.h"
#import "HpsAddress.h"

@interface HpsPaxCreditVerifyBuilder : NSObject
{
    HpsPaxDevice *device;
}

@property (nonatomic, readwrite) int referenceNumber;
@property (nonatomic, strong) HpsCreditCard *creditCard;
@property (nonatomic, strong) HpsAddress *address;
@property (nonatomic, readwrite) BOOL requestMultiUseToken;
@property (nonatomic, strong) NSString *clientTransactionId;

- (void) execute:(void(^)(HpsPaxCreditResponse*, NSError*))responseBlock;
- (id)initWithDevice: (HpsPaxDevice*)paxDevice;

 
@end
