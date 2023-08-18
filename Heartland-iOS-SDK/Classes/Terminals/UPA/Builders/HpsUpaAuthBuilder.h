#import <Foundation/Foundation.h>
#import "HpsCreditCard.h"
#import "HpsAddress.h"
#import "HpsTransactionDetails.h"
#import "HpsUpaResponse.h"
#import "HpsUpaDevice.h"

@interface HpsUpaAuthBuilder : NSObject
{
    HpsUpaDevice *device;
}

@property (nonatomic, readwrite) int referenceNumber;
@property (nonatomic, strong) NSDecimalNumber *amount;
@property (nonatomic, strong) NSString *ecrId;
@property (nonatomic, strong) NSString *clerkId;
@property (nonatomic, strong) NSString *issuerRefNumber;
@property (nonatomic, strong) NSString *transactionId;

// HSA/FSA Values
@property (nonatomic, strong) NSDecimalNumber *prescriptionAmount;
@property (nonatomic, strong) NSDecimalNumber *clinicAmount;
@property (nonatomic, strong) NSDecimalNumber *dentalAmount;
@property (nonatomic, strong) NSDecimalNumber *visionOpticalAmount;

- (void) execute:(void(^)(HpsUpaResponse*, NSError*))responseBlock;
- (id)initWithDevice: (HpsUpaDevice*)upaDevice;

@end
