#import "HpsHeartSipCreditVoidBuilder.h"

@interface HpsHeartSipCreditVoidBuilder ()

@property (readwrite, strong) NSNumber *version;
@property (readwrite, strong) NSString *ecrId;

@end

@implementation HpsHeartSipCreditVoidBuilder

- (id)initWithDevice: (HpsHeartSipDevice*)HeartSipDevice{
	self = [super init];
	if (self != nil)
		{
		device = HeartSipDevice;
		self.version = [NSNumber numberWithDouble:1.0];
		self.ecrId = @"1004";
		}
	return self;
}

- (void) execute:(void(^)(id<IHPSDeviceResponse>, NSError*))responseBlock{

	[self validate];

	HpsHeartSipRequest *request_Void = [[HpsHeartSipRequest alloc]initWithVoidTransacationRequestwithVersion:(self.version.stringValue ? self.version.stringValue :@"1.0") withEcrId:( self.ecrId ? self.ecrId :@"1004") withRequest:HSIP_MSG_ID_toString[CREDIT_VOID] withTransactionID:self.transactionId.stringValue];

	[device processTransactionWithRequest:request_Void withResponseBlock:^(id<IHPSDeviceResponse> respose, NSError *error)
	 {
	 dispatch_async(dispatch_get_main_queue(), ^{
		 responseBlock(respose, error);
	 });
	 }];
}

- (void) validate
{
	if (self.transactionId.integerValue == 0 || self.transactionId == nil)
		{
		@throw [NSException exceptionWithName:@"HpsHeartSipException" reason:@"transactionId is required." userInfo:nil];
		}

}

@end
