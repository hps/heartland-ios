#import "HpsHpaGiftBalanceBuilder.h"

@interface HpsHpaGiftBalanceBuilder()

@property (readwrite, strong) NSString *cardGroup;
@property (readwrite, strong) NSNumber *version;
@property (readwrite, strong) NSString *ecrId;
@property (readwrite, strong) NSNumber *confirmAmount;

@end

@implementation HpsHpaGiftBalanceBuilder

- (id)initWithDevice: (HpsHpaDevice*)HpaDevice{
	self = [super init];
	if (self != nil)
		{
		device = HpaDevice;
		self.version = [NSNumber numberWithDouble:1.0];
		self.ecrId = @"1004";
		self.confirmAmount = [NSNumber numberWithDouble:0];
		self.cardGroup = @"Gift";
		}
	return self;
}


- (void) execute:(void(^)(id<IHPSDeviceResponse>, NSError*))responseBlock{

		//[self validate];
	HpsHpaRequest *request_balance = [[HpsHpaRequest alloc]initWithGiftBalanceWihVersion:self.version.stringValue withEcrId:self.ecrId withRequest:@"BalanceInquiry" withCardGroup:self.cardGroup];
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
	//		@throw [NSException exceptionWithName:@"HpsHpaException" reason:@"currencyType is required." userInfo:nil];
	//	}
	//}

@end
