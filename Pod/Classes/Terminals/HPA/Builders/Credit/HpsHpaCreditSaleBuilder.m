#import "HpsHpaCreditSaleBuilder.h"

@interface HpsHpaCreditSaleBuilder()
@property (readwrite, strong) NSString  *cardGroup;
@property (readwrite, strong) NSNumber *version;
@property (readwrite, strong) NSString *ecrId;
@property (readwrite, strong) NSNumber *confirmAmount;
@property (nonatomic, strong) NSNumber *invoiceNbr;
@property (nonatomic, strong) NSNumber *baseAmount;
@property (nonatomic, strong) NSNumber *taxAmount;
@property (nonatomic, strong) NSNumber *totalAmount;
@property (nonatomic, strong) NSString *serverLabel;

@end

@implementation HpsHpaCreditSaleBuilder

- (id)initWithDevice: (HpsHpaDevice*)HpaDevice{
	self = [super init];
	if (self != nil)
		{
		device = HpaDevice;
		self.version = [NSNumber numberWithDouble:1.0];
		self.ecrId = @"1004";
		self.confirmAmount = [NSNumber numberWithDouble:0];
		self.cardGroup = @"Credit";
		}
	return self;
}

- (void) execute:(void(^)(id<IHPSDeviceResponse>, NSError*))responseBlock{

	self.totalAmount = [NSNumber numberWithFloat:(self.amount.doubleValue * 100)] ;
	self.invoiceNbr = [NSNumber numberWithInteger:self.referenceNumber];
	[self validate];
	self.cardGroup = @"Credit";
	HpsHpaRequest *request_sale = [[HpsHpaRequest alloc]
										initWithCreditSaleRequestwithVersion:(self.version.stringValue ? self.version.stringValue :@"1.0")
										withEcrId:( self.ecrId ? self.ecrId :@"1004")
										withRequest:HPA_MSG_ID_toString[CREDIT_SALE]
										withCardGroup:self.cardGroup
										withConfirmAmount:(self.confirmAmount.stringValue ?self.confirmAmount.stringValue :@"0")
										withInvoiceNbr:(self.invoiceNbr.stringValue ? self.invoiceNbr.stringValue :nil)
										withBaseAmount:(self.baseAmount.stringValue ?self.baseAmount.stringValue :nil)
										withTaxAmount:(self.taxAmount.stringValue ?self.taxAmount.stringValue :nil)
										withTotalAmount:(self.totalAmount.stringValue ? self.totalAmount.stringValue :nil)
										withServerLabel:(self.serverLabel ? self.serverLabel :nil)];

	request_sale.RequestId = self.referenceNumber;

	[device processTransactionWithRequest:request_sale withResponseBlock:^(id<IHPSDeviceResponse> respose, NSError *error)
	 {
	 dispatch_async(dispatch_get_main_queue(), ^{
		 responseBlock(respose, error);
	 });
	 }];

}

- (void) validate
{
	if (self.totalAmount == nil || self.totalAmount.floatValue <= 0) {
		@throw [NSException exceptionWithName:@"HpsHpaException" reason:@"Amount is required." userInfo:nil];
	}
}
@end
