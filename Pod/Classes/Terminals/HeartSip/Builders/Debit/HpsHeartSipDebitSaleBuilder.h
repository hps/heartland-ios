#import <Foundation/Foundation.h>
#import "HpsHeartSipDevice.h"

@interface HpsHeartSipDebitSaleBuilder : NSObject
{
	HpsHeartSipDevice *device;
}

@property (nonatomic, readwrite) int referenceNumber;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSNumber *cashBack;
@property (nonatomic, readwrite) BOOL allowDuplicates;

- (void) execute:(void(^)(id<IHPSDeviceResponse>, NSError*))responseBlock;
- (id)initWithDevice: (HpsHeartSipDevice*)HeartSipDevice;

@end
