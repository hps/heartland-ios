//  Copyright (c) 2017 Heartland Payment Systems. All rights reserved.

#import "HpsHeartSipGiftAddValueBuilder.h"

@interface HpsHeartSipGiftAddValueBuilder()

@property (readwrite, strong) NSString  *cardGroup;
@property (readwrite, strong) NSNumber *version;
@property (readwrite, strong) NSString *ecrId;
@property (readwrite, strong) NSNumber *confirmAmount;
@property (nonatomic, strong) NSNumber *totalAmount;

@end
@implementation HpsHeartSipGiftAddValueBuilder

- (id)initWithDevice: (HpsHeartSipDevice*)HeartSipDevice{
	self = [super init];
	if (self != nil)
		{
			device = HeartSipDevice;
			self.version = [NSNumber numberWithDouble:1.0];
			self.ecrId = @"1004";
			self.confirmAmount = [NSNumber numberWithDouble:0];
			self.cardGroup = @"Gift";
		}
	return self;
}

- (void) execute:(void(^)(id<IHPSDeviceResponse>, NSError*))responseBlock{
	self.totalAmount = [NSNumber numberWithFloat:(self.amount.doubleValue * 100)];
    [self validate];

	HpsHeartSipRequest *request_add_value = [[HpsHeartSipRequest alloc] initWithAddValueWihVersion:self.version.stringValue withEcrId:self.ecrId withRequest:@"AddValue" withTotalAmount:self.totalAmount.stringValue];
	request_add_value.RequestId = self.referenceNumber;

	[device processTransactionWithRequest:request_add_value withResponseBlock:^(id<IHPSDeviceResponse> respose, NSError *error)
	 {
	 dispatch_async(dispatch_get_main_queue(), ^{
		 responseBlock(respose, error);
	 });
	 }];
	
}

- (void) validate
{
 if (self.amount == nil || self.amount <= 0) {
	 @throw [NSException exceptionWithName:@"HpsHeartSipException" reason:@"Amount is required." userInfo:nil];
 }

}

@end
