#import "HpsHpaSafBuilder.h"
#import "HpsHpaRequest.h"

@interface HpsHpaSafBuilder()
@property (readwrite, strong) NSNumber *version;
@property (readwrite, strong) NSString *ecrId;

@end

@implementation HpsHpaSafBuilder

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

-(void) execute:(void(^)(HpsHpaSafResponse*, NSError*))responseBlock{
	NSLog(@"Executing SendSAF");

	HpsHpaRequest *request_SAF = [[HpsHpaRequest alloc]initSendSAFWithVersion:(self.version.stringValue ? self.version.stringValue :@"1.0") withEcrId:( self.ecrId ? self.ecrId :@"1004") andRequest:HPA_MSG_ID_toString[SEND_SAF]];

	request_SAF.RequestId = self.referenceNumber;
	[device processSAFWithRequest:request_SAF withResponseBlock:^(HpsHpaSafResponse* response, NSError *error)
	 {
	 dispatch_async(dispatch_get_main_queue(), ^{
		 responseBlock(response, error);
	 });
	 }];

}
@end
