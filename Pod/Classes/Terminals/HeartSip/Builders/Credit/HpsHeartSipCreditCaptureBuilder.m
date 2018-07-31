#import "HpsHeartSipCreditCaptureBuilder.h"

@interface HpsHeartSipCreditCaptureBuilder()

@property (readwrite, strong) NSNumber *version;
@property (readwrite, strong) NSString *ecrId;
@property (readwrite, strong) NSNumber *confirmAmount;
@property (readwrite, strong) NSString *cardGroup;
@property (readwrite, strong) NSString *request;
@property (nonatomic, strong) NSNumber *totalAmount;

@end

@implementation HpsHeartSipCreditCaptureBuilder

- (id)initWithDevice: (HpsHeartSipDevice*)HeartSipDevice{
	self = [super init];
	if (self != nil)
		{
		device = HeartSipDevice;
		self.version = [NSNumber numberWithDouble:1.0];
		self.ecrId = @"1004";
		self.confirmAmount = [NSNumber numberWithDouble:0];
		self.cardGroup = @"Credit";
		self.request = @"CreditAuthComplete";
		}
	return self;
}


- (void) execute:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock{
	NSLog(@"capture Builder Excecute");
	self.totalAmount = [NSNumber numberWithFloat:(self.amount.doubleValue * 100)] ;
	[self validate];

	HpsHeartSipRequest *request_authComplete = [ [HpsHeartSipRequest alloc]initWithCreditAuthCompleteWithVersion:self.version.stringValue withEcrId:self.ecrId withRequest:self.request withTransactionId:self.transactionId.stringValue withConfirmAmount:self.confirmAmount.stringValue withTotalAmount:self.totalAmount.stringValue withTipAmount:self.gratuity.stringValue];

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
		@throw [NSException exceptionWithName:@"HpsHeartSipException" reason:@"transactionId is required." userInfo:nil];
	}

}

@end
