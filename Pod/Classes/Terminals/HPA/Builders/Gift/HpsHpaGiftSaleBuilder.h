#import <Foundation/Foundation.h>
#import "HpsHpaDevice.h"
#import "HpsTransactionDetails.h"

@interface HpsHpaGiftSaleBuilder : NSObject
{
	HpsHpaDevice *device;
}

	//@property (nonatomic) int currencyType;
@property (nonatomic, readwrite) int referenceNumber;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) HpsTransactionDetails *details;

- (void) execute:(void(^)(id<IHPSDeviceResponse>, NSError*))responseBlock;
- (id)initWithDevice: (HpsHpaDevice*)HpaDevice;

@end
