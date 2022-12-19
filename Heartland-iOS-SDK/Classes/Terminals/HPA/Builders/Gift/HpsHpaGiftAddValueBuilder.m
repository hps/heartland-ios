#import "HpsHpaGiftAddValueBuilder.h"

@interface HpsHpaGiftAddValueBuilder()

@property (readwrite, strong) NSString *cardGroup;
@property (readwrite, strong) NSNumber *version;
@property (readwrite, strong) NSString *ecrId;
@property (readwrite, strong) NSNumber *confirmAmount;
@property (nonatomic, strong) NSNumber *totalAmount;

@end

@implementation HpsHpaGiftAddValueBuilder

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
    [self validate];

	HpsHpaRequest *request_add_value = [[HpsHpaRequest alloc] initWithAddValueWihVersion:self.version.stringValue withEcrId:self.ecrId withRequest:@"AddValue" withTotalAmount:self.totalAmount.stringValue];
	request_add_value.RequestId = self.referenceNumber;

	[device processTransactionWithRequest:request_add_value withResponseBlock:^(id<IHPSDeviceResponse> respose, NSError *error)
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

}

@end
