#import "HpsHpaInitializeResponse.h"

@implementation HpsHpaInitializeResponse

-(id)initWithHpaInitializeResponse:(NSData *)data withParameters:(NSArray *)messageIds
{
	if (self = [super initWithHpaBaseResponse:data withParameters:messageIds])
		{
		self.serialNumber = self.terminalSerialNumber;
		}
	return self;
}

- (void) mapResponse:(id <HpaResposeInterface>) response;
{
	[super mapResponse:response];
}

-(NSString*)toString{

	return [NSString stringWithFormat:@"\n\n #### toString = \n serial number = %@ version = %@ Device ECR ID = %@ Device SIP ID = %@ Device Response Code = %@  Device response = %@ \n\n",self.serialNumber, self.version,self.ecrId,self.hpaId,self.deviceResponseCode,self.responseText];
}
@end
