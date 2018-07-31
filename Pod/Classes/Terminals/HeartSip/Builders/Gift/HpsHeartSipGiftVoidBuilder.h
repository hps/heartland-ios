#import <Foundation/Foundation.h>
#import "HpsHeartSipDevice.h"

@interface HpsHeartSipGiftVoidBuilder : NSObject
{
	HpsHeartSipDevice *device;
}

@property (nonatomic, readwrite) int transactionId;
@property (nonatomic, readwrite) int referenceNumber;

- (void) execute:(void(^)(id<IHPSDeviceResponse>, NSError*))responseBlock;
- (id)initWithDevice: (HpsHeartSipDevice*)HeartSipDevice;

@end
