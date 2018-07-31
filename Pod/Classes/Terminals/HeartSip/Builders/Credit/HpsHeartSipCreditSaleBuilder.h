#import <Foundation/Foundation.h>
#import "HpsHeartSipDevice.h"

@interface HpsHeartSipCreditSaleBuilder : NSObject
{
	HpsHeartSipDevice *device;
}

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, readwrite) int referenceNumber;

- (void) execute:(void(^)(id<IHPSDeviceResponse>, NSError*))responseBlock;
- (id)initWithDevice: (HpsHeartSipDevice*)HeartSipDevice;

@end
