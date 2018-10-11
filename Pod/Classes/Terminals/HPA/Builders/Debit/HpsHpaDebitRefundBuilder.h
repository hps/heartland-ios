#import <Foundation/Foundation.h>
#import "HpsHpaDevice.h"

@interface HpsHpaDebitRefundBuilder : NSObject
{
	HpsHpaDevice *device;
}

@property (nonatomic, readwrite) int referenceNumber;
@property (nonatomic, readwrite) int transactionId;
@property (nonatomic, strong) NSNumber *amount;

- (void) execute:(void(^)(id<IHPSDeviceResponse>, NSError*))responseBlock;
- (id)initWithDevice: (HpsHpaDevice*)HpaDevice;

@end
