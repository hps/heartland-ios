#import "HpsHpaGiftVoidBuilder.h"

@interface HpsHpaGiftVoidBuilder()

@property (readwrite, strong) NSString *cardGroup;
@property (readwrite, strong) NSNumber *version;
@property (readwrite, strong) NSString *ecrId;
@property (readwrite, strong) NSNumber *confirmAmount;

@end

@implementation HpsHpaGiftVoidBuilder

- (id)initWithDevice: (HpsHpaDevice*)HpaDevice{
	self = [super init];
	if (self != nil)
		{
		device = HpaDevice;
		self.version = [NSNumber numberWithDouble:1.0];
		self.ecrId = @"1004";
		self.confirmAmount = [NSNumber numberWithDouble:0];
		//self.cardGroup = @"Gift";
		}
	return self;
}

- (void) execute:(void(^)(id<IHPSDeviceResponse>, NSError*))responseBlock{

	[self validate];

	self.cardGroup = @"GIFT";

	HpsHpaRequest *request_Void = [[HpsHpaRequest alloc]initWithVoidTransacationRequestwithVersion:(self.version.stringValue ? self.version.stringValue :@"1.0") withEcrId:( self.ecrId ? self.ecrId :@"1004") withRequest:HPA_MSG_ID_toString[CREDIT_VOID] withCardGroup:self.cardGroup withTransactionID:[NSString stringWithFormat:@"%d",self.transactionId]];
	request_Void.RequestId = self.referenceNumber;

	[device processTransactionWithRequest:request_Void withResponseBlock:^(id<IHPSDeviceResponse> respose, NSError *error)
	 {
	 dispatch_async(dispatch_get_main_queue(), ^{
		 responseBlock(respose, error);
	 });
	 }];

}

- (void) validate
{
	if (self.transactionId <= 0) {
		@throw [NSException exceptionWithName:@"HpsHpaException" reason:@"transactionId is required." userInfo:nil];
	}
}

@end
