#import <Foundation/Foundation.h>
#import "HpsHpaDevice.h"

@interface HpsHpaGiftBalanceBuilder : NSObject
{
	HpsHpaDevice *device;
}
	//@property (nonatomic) int currencyType;
@property (nonatomic, readwrite) int referenceNumber;
@property (nonatomic, strong) NSNumber *amount;

- (void) execute:(void(^)(id<IHPSDeviceResponse>, NSError*))responseBlock;
- (id)initWithDevice: (HpsHpaDevice*)HpaDevice;

@end
