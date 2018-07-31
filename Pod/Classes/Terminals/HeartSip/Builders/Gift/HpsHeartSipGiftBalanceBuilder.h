#import <Foundation/Foundation.h>
#import "HpsHeartSipDevice.h"

@interface HpsHeartSipGiftBalanceBuilder : NSObject
{
	HpsHeartSipDevice *device;
}
	//@property (nonatomic) int currencyType;
@property (nonatomic, readwrite) int referenceNumber;
@property (nonatomic, strong) NSNumber *amount;

- (void) execute:(void(^)(id<IHPSDeviceResponse>, NSError*))responseBlock;
- (id)initWithDevice: (HpsHeartSipDevice*)HeartSipDevice;

@end
