	//  Copyright (c) 2017 Heartland Payment Systems. All rights reserved.

#import "HpsHeartSipInitializeResponse.h"

@implementation HpsHeartSipInitializeResponse

-(id)initWithHeartSipInitializeResponse:(NSData *)data withParameters:(NSArray *)messageIds
{
	if (self = [super initWithHeartSipBaseResponse:data withParameters:messageIds])
		{
		self.serialNumber = self.terminalSerialNumber;
		}
	return self;
}

- (void) mapResponse:(id <SipResposeInterface>) response;
{
	[super mapResponse:response];
}

-(NSString*)toString{

	return [NSString stringWithFormat:@"\n\n #### toString = \n serial number = %@ version = %@ Device ECR ID = %@ Device SIP ID = %@ Device Response Code = %@  Device response = %@ \n\n",self.serialNumber, self.version,self.ecrId,self.sipId,self.deviceResponseCode,self.responseText];
}
@end
