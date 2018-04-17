//  Copyright (c) 2017 Heartland Payment Systems. All rights reserved.

#import <Foundation/Foundation.h>
#import "HpsHeartSipDevice.h"

@interface HpsHeartSipCreditRefundBuilder : NSObject
{
    HpsHeartSipDevice *device;
}

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, readwrite) int referenceNumber;

- (void) execute:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
- (id)initWithDevice: (HpsHeartSipDevice*)HeartSipDevice;

@end
