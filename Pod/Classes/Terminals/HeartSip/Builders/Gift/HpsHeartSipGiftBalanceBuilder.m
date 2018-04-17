	//  Copyright (c) 2017 Heartland Payment Systems. All rights reserved.

#import "HpsHeartSipGiftBalanceBuilder.h"
@interface HpsHeartSipGiftBalanceBuilder()

@property (readwrite, strong) NSString  *cardGroup;
@property (readwrite, strong) NSNumber *version;
@property (readwrite, strong) NSString *ecrId;
@property (readwrite, strong) NSNumber *confirmAmount;

@end

@implementation HpsHeartSipGiftBalanceBuilder
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

		//[self validate];
	HpsHeartSipRequest *request_balance = [[HpsHeartSipRequest alloc]initWithGiftBalanceWihVersion:self.version.stringValue withEcrId:self.ecrId withRequest:@"BalanceInquiry" withCardGroup:self.cardGroup];
	request_balance.RequestId = self.referenceNumber;

	[device processTransactionWithRequest:request_balance withResponseBlock:^(id<IHPSDeviceResponse> respose, NSError *error)
	 {
	 dispatch_async(dispatch_get_main_queue(), ^{
		 responseBlock(respose, error);
	 });
	 }];
}

	//- (void) validate
	//{
	//	if (self.currencyType < 0) {
	//		@throw [NSException exceptionWithName:@"HpsHeartSipException" reason:@"currencyType is required." userInfo:nil];
	//	}
	//}

@end
