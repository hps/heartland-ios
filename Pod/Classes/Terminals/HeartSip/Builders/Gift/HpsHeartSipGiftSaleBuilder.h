	//  Copyright (c) 2017 Heartland Payment Systems. All rights reserved.

#import <Foundation/Foundation.h>
#import "HpsHeartSipDevice.h"
#import "HpsTransactionDetails.h"

@interface HpsHeartSipGiftSaleBuilder : NSObject
{
	HpsHeartSipDevice *device;
}

	//@property (nonatomic) int currencyType;
@property (nonatomic, readwrite) int referenceNumber;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) HpsTransactionDetails *details;

- (void) execute:(void(^)(id<IHPSDeviceResponse>, NSError*))responseBlock;
- (id)initWithDevice: (HpsHeartSipDevice*)HeartSipDevice;

@end
