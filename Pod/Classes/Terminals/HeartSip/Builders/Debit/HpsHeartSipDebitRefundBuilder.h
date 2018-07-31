#import <Foundation/Foundation.h>
#import "HpsHeartSipDevice.h"

@interface HpsHeartSipDebitRefundBuilder : NSObject
{
	HpsHeartSipDevice *device;
}

@property (nonatomic, readwrite) int referenceNumber;
@property (nonatomic, readwrite) int transactionId;
@property (nonatomic, strong) NSNumber *amount;

- (void) execute:(void(^)(id<IHPSDeviceResponse>, NSError*))responseBlock;
- (id)initWithDevice: (HpsHeartSipDevice*)HeartSipDevice;

@end
