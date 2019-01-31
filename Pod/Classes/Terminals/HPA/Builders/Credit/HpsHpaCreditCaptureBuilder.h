#import <Foundation/Foundation.h>
#import "HpsHpaDevice.h"

@interface HpsHpaCreditCaptureBuilder : NSObject
{
	HpsHpaDevice *device;
}

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSNumber *gratuity;
@property (nonatomic, readwrite) NSNumber *transactionId;
@property (nonatomic, readwrite) int referenceNumber;

- (void) execute:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
- (id)initWithDevice: (HpsHpaDevice*)HpaDevice;

@end
