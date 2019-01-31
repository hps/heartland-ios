#import "HpsHpaGiftSaleBuilder.h"

@interface HpsHpaGiftSaleBuilder()

@property (readwrite, strong) NSString *cardGroup;
@property (readwrite, strong) NSNumber *version;
@property (readwrite, strong) NSString *ecrId;
@property (readwrite, strong) NSNumber *confirmAmount;
@property (nonatomic, strong) NSNumber *tipAmount;
@property (nonatomic, strong) NSNumber *baseAmount;
@property (nonatomic, strong) NSNumber *taxAmount;
@property (nonatomic, strong) NSNumber *totalAmount;
@property (nonatomic, strong) NSNumber *ebtAmount;

@end

@implementation HpsHpaGiftSaleBuilder

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
	self.totalAmount = [NSNumber numberWithFloat:(self.amount.doubleValue * 100)];
	self.baseAmount = [NSNumber numberWithFloat:(self.amount.doubleValue * 100)];
	self.ebtAmount = [NSNumber numberWithFloat:(self.amount.doubleValue * 100)];
	[self validate];

	HpsHpaRequest *request_sale = [[HpsHpaRequest alloc]
										initWithCreditSaleRequestwithVersion:(self.version.stringValue ? self.version.stringValue :@"1.0") withEcrId:(self.ecrId ? self.ecrId :@"1004") withRequest:HPA_MSG_ID_toString[CREDIT_SALE] withCardGroup:self.cardGroup withConfirmAmount:(self.confirmAmount.stringValue ?self.confirmAmount.stringValue :@"0") withBaseAmount:(self.baseAmount.stringValue ? self.baseAmount.stringValue :nil) withTipAmount:(self.tipAmount.stringValue ? self.tipAmount.stringValue :nil) withTaxAmount:(self.taxAmount.stringValue ?self.taxAmount.stringValue :nil) withEBTAmount:(self.ebtAmount.stringValue ? self.ebtAmount.stringValue :nil) withTotalAmount:(self.totalAmount.stringValue ? self.totalAmount.stringValue :nil)];

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
	if (self.amount == nil || self.amount <= 0) {
		@throw [NSException exceptionWithName:@"HpsHpaException" reason:@"Amount is required." userInfo:nil];
	}
//	if (self.currencyType < 0) {
//		@throw [NSException exceptionWithName:@"HpsHpaException" reason:@"currencyType is required." userInfo:nil];
//	}
}

@end
