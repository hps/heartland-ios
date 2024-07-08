#import <Foundation/Foundation.h>
#import "HpsCreditCard.h"
#import "HpsAddress.h"
#import "HpsTransactionDetails.h"
#import "HpsUpaResponse.h"
#import "HpsUpaDevice.h"
#import "HpsEnums.h"

@interface HpsUpaSaleBuilder : NSObject
{
    HpsUpaDevice *device;
}

@property (nonatomic, readwrite) int referenceNumber;
@property (nonatomic, strong) NSDecimalNumber *amount;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, readwrite) BOOL requestMultiUseToken;
@property (nonatomic, strong) HpsTransactionDetails *details;
@property (nonatomic, strong) NSDecimalNumber *gratuity;
@property (nonatomic, strong) NSString *ecrId;
@property (nonatomic, strong) NSString *clerkId;
@property (nonatomic, strong) NSDecimalNumber *taxAmount;
@property (nonatomic, readwrite) HpsStoredCardInitiator storedCardInitiator;
@property (nonatomic, strong) NSString *cardBrandTransactionId;
@property (nonatomic, strong) NSNumber *allowDuplicate;

// HSA/FSA Values
@property (nonatomic, strong) NSDecimalNumber *prescriptionAmount;
@property (nonatomic, strong) NSDecimalNumber *clinicAmount;
@property (nonatomic, strong) NSDecimalNumber *dentalAmount;
@property (nonatomic, strong) NSDecimalNumber *visionOpticalAmount;

- (void) execute:(void(^)(HpsUpaResponse*, NSError*))responseBlock;
- (id)initWithDevice: (HpsUpaDevice*)upaDevice;
- (void) executeForUPAUSA:(void(^)(HpsUpaResponse*, NSString*, NSError*))responseBlock;
@end
