#import <Foundation/Foundation.h>
#import "HpsHpaDevice.h"

@interface HpsHpaGiftAddValueBuilder : NSObject
{
    HpsHpaDevice *device;
}

@property (nonatomic, readwrite) int referenceNumber;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic) int currencyType;

- (void) execute:(void(^)(id<IHPSDeviceResponse>, NSError*))responseBlock;
- (id)initWithDevice: (HpsHpaDevice*)HpaDevice;

@end
