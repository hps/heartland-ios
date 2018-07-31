#import <Foundation/Foundation.h>
#import "HpsHeartSipDevice.h"

@interface HpsHeartSipCreditVoidBuilder : NSObject
{
	HpsHeartSipDevice *device;
}

@property (nonatomic, readwrite) NSNumber *transactionId;

- (void) execute:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
- (id)initWithDevice: (HpsHeartSipDevice*)HeartSipDevice;

@end
