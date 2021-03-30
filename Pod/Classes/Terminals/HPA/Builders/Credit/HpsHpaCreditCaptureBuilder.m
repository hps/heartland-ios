#import "HpsHpaCreditCaptureBuilder.h"

@interface HpsHpaCreditCaptureBuilder()

@property (readwrite, strong) NSNumber *version;
@property (readwrite, strong) NSString *ecrId;
@property (nonatomic, strong) NSNumber *totalAmount;

@end

@implementation HpsHpaCreditCaptureBuilder

- (id)initWithDevice: (HpsHpaDevice*)HpaDevice{
	self = [super init];
	if (self != nil)
		{
		device = HpaDevice;
		self.version = [NSNumber numberWithDouble:1.0];
		self.ecrId = @"1004";
		}
	return self;
}


- (void) execute:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock{
	NSLog(@"capture Builder Excecute");
	self.totalAmount = [NSNumber numberWithFloat:(self.amount.doubleValue * 100)] ;
	[self validate];

	HpsHpaRequest *request_authComplete = [ [HpsHpaRequest alloc]initWithCreditAuthCompleteWithVersion:self.version.stringValue withEcrId:self.ecrId withRequest:HPA_MSG_ID_toString[CAPTURE] withTransactionId:self.transactionId.stringValue withTotalAmount:self.totalAmount.stringValue withTipAmount:self.gratuity.stringValue];
	
	request_authComplete.RequestId = self.referenceNumber;

	[device processTransactionWithRequest:request_authComplete withResponseBlock:^(id<IHPSDeviceResponse> respose, NSError *error)
	 {
		dispatch_async(dispatch_get_main_queue(), ^{
		 responseBlock(respose, error);
	 });
	 }];
}

- (void) validate
{
	if (self.transactionId <= 0 || self.transactionId == nil) {
		@throw [NSException exceptionWithName:@"HpsHpaException" reason:@"transactionId is required." userInfo:nil];
	}

}

@end
