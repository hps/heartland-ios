#import <Foundation/Foundation.h>
#import "HpsHpaDevice.h"

@interface HpsHpaCreditVoidBuilder : NSObject
{
	HpsHpaDevice *device;
}

@property (nonatomic, readwrite) NSNumber *transactionId;

- (void) execute:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
- (id)initWithDevice: (HpsHpaDevice*)HpaDevice;

@end
