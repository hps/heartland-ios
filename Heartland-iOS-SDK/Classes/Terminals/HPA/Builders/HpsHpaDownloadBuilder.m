#import "HpsHpaDownloadBuilder.h"

#define DOWNLOAD @"Download"
#define HUDSPORT @"8001"

@interface HpsHpaDownloadBuilder ()

@property (nonatomic, strong) NSNumber *version;
@property (nonatomic, strong) NSString *ecrId;

@end

@implementation HpsHpaDownloadBuilder

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

	NSLog(@"Execute Download....");

	HpsHpaRequest *request_auth =  [[HpsHpaRequest alloc] initToStartDownloadWithVersion:(self.version.stringValue ? self.version.stringValue :@"1.0") withEcrId:(self.ecrId? self.ecrId :@"1004") withRequest:DOWNLOAD withHUDSURL:(self.url ? self.url :@"") withHUDSPORT:HUDSPORT withTerminal:(self.terminalId ? self.terminalId :@"") withAppId:(self.applicationId ? self.applicationId :@"") withDownloadType:(self.downloadType ? self.downloadType :@"") andDownloadTime:(self.downloadTime ? self.downloadTime :@"")];
	
	request_auth.RequestId = self.referenceNumber;

	[device processTransactionWithRequest:request_auth withResponseBlock:^(id <IHPSDeviceResponse> respose, NSError *error)
	 {
	 dispatch_async(dispatch_get_main_queue(), ^{
		 responseBlock(respose, error);
	 });
	 }];
}


@end
