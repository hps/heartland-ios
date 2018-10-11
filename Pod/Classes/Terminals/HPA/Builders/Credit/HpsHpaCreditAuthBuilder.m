#import "HpsHpaCreditAuthBuilder.h"

@interface HpsHpaCreditAuthBuilder ()

@property (readwrite, strong) NSNumber *version;
@property (readwrite, strong) NSString *ecrId;
@property (readwrite, strong) NSNumber *confirmAmount;
@property (readwrite, strong) NSString  *cardGroup;
@property (nonatomic, strong) NSNumber *invoiceNbr;
@property (nonatomic, strong) NSNumber *totalAmount;
@end

@implementation HpsHpaCreditAuthBuilder

- (id)initWithDevice: (HpsHpaDevice*)HpaDevice{
	self = [super init];
	if (self != nil)
		{
		device = HpaDevice;
		self.version = [NSNumber numberWithDouble:1.0];
		self.ecrId = @"1004";
		self.cardGroup = @"Credit";
		}
	return self;
}

- (void) execute:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock{
	NSLog(@"Auth builder Execute ....");
	self.totalAmount = [NSNumber numberWithFloat:(self.amount.doubleValue * 100)];
	self.confirmAmount = self.totalAmount;
	self.invoiceNbr = [NSNumber numberWithInteger:self.referenceNumber];
	[self validate];
	HpsHpaRequest *request_auth = [[HpsHpaRequest alloc] initWithCreditAuthRequestwithVersion:(self.version.stringValue ? self.version.stringValue :@"1.0") withEcrId:( self.ecrId ? self.ecrId :@"1004") withRequest:HPA_MSG_ID_toString[CREDIT_AUTH] withConfirmAmount:(self.confirmAmount.stringValue ?self.confirmAmount.stringValue :@"0") withInvoiceNbr:self.invoiceNbr.stringValue withTotalAmount:self.totalAmount.stringValue];
	request_auth.RequestId = self.referenceNumber;
	[device processTransactionWithRequest:request_auth withResponseBlock:^(id<IHPSDeviceResponse> respose, NSError *error)
	 {
	 dispatch_async(dispatch_get_main_queue(), ^{
		 responseBlock(respose, error);
	 });
	 }];}

- (void) validate
{
		//    //No amount
	if (self.totalAmount == nil || self.totalAmount <= 0) {
		@throw [NSException exceptionWithName:@"HpsHpaException" reason:@"Amount is required." userInfo:nil];
	}
}


@end
