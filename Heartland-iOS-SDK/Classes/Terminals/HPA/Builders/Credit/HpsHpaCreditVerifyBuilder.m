#import "HpsHpaCreditVerifyBuilder.h"

@interface HpsHpaCreditVerifyBuilder()
@property (readwrite, strong) NSNumber *version;
@property (readwrite, strong) NSString *ecrId;
@property (readwrite, strong) NSString *cardGroup;
@property (nonatomic, strong) NSNumber *totalAmount;
@property (nonatomic, readwrite) NSNumber *invoiceNumber;

@end

@implementation HpsHpaCreditVerifyBuilder

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

	self.totalAmount = [NSNumber numberWithFloat:(self.amount.doubleValue * 100)];

	[self validate];

	self.cardGroup = @"All";

	HpsHpaRequest *request_verify = [[HpsHpaRequest alloc] initWithCreditVerifyRequestwithVersion:(self.version.stringValue ? self.version.stringValue :@"1.0") withEcrId:(self.ecrId ? self.ecrId :@"1004") withRequest:HPA_MSG_ID_toString[CARD_VERIFY] withCardGroup:self.cardGroup];

	request_verify.RequestId = self.referenceNumber;

	[device processTransactionWithRequest:request_verify withResponseBlock:^(id<IHPSDeviceResponse> respose, NSError *error){
	 dispatch_async(dispatch_get_main_queue(), ^{
		 responseBlock(respose, error);
	 });

	}];
}

- (void) validate{}

@end
