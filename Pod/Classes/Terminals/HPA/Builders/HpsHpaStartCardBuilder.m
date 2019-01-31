
#import "HpsHpaStartCardBuilder.h"

#define CARD_REQ @"StartCard"

@interface HpsHpaStartCardBuilder ()

@property (nonatomic, strong) NSNumber *version;
@property (nonatomic, strong) NSString *ecrId;

@end

@implementation HpsHpaStartCardBuilder

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

	NSLog(@"Execute Start Card....");

	HpsHpaRequest *request_auth =  [[HpsHpaRequest alloc] initToStartCardWithVersion:(self.version.stringValue ? self.version.stringValue :@"1.0") withEcrId:(self.ecrId ? self.ecrId :@"1004") withRequest:CARD_REQ andCardGroup:(self.cardGroup ? self.cardGroup :@"")];

	request_auth.RequestId = self.referenceNumber;

	[device processTransactionWithRequest:request_auth withResponseBlock:^(id <IHPSDeviceResponse> respose, NSError *error)
	 {
	 dispatch_async(dispatch_get_main_queue(), ^{
		 responseBlock(respose, error);
	 });
	 }];
}

@end
