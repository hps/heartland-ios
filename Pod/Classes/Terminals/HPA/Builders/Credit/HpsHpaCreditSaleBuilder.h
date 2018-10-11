#import <Foundation/Foundation.h>
#import "HpsHpaDevice.h"

@interface HpsHpaCreditSaleBuilder : NSObject
{
	HpsHpaDevice *device;
}

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, readwrite) int referenceNumber;

- (void) execute:(void(^)(id<IHPSDeviceResponse>, NSError*))responseBlock;
- (id)initWithDevice: (HpsHpaDevice*)HpaDevice;

@end
