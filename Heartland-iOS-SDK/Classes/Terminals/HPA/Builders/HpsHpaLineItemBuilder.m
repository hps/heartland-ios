#import "HpsHpaLineItemBuilder.h"

@interface HpsHpaLineItemBuilder ()

@property (nonatomic, strong) NSNumber *version;
@property (nonatomic, strong) NSString *ecrId;

@end

@implementation HpsHpaLineItemBuilder

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

- (void) execute:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock {

	NSLog(@"Execute LineItem....");

	HpsHpaRequest *request_auth =  [[HpsHpaRequest alloc] initToAddLineItemWithVersion:self.version.stringValue withEcrId:self.ecrId andRequest:@"LineItem"];

	request_auth.RequestId = self.referenceNumber;
	request_auth.LineItemTextLeft = self.textLeft;
	request_auth.LineItemRunningTextLeft = self.r_textLeft;
	request_auth.LineItemTextRight = self.textRight;
	request_auth.LineItemRunningTextRight = self.r_textRight;

	[device processTransactionWithRequest:request_auth withResponseBlock:^(id <IHPSDeviceResponse> respose, NSError *error)
	 {
	 dispatch_async(dispatch_get_main_queue(), ^{
		 responseBlock(respose, error);
	 });
	 }];
}

@end
