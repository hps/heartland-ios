	//  Copyright (c) 2016 Heartland Payment Systems. All rights reserved.

#import "HpsTerminalResponse.h"
#import "HpsHeartSipSharedParams.h"

@implementation HpsTerminalResponse

- (void) mapResponse:(id <SipResposeInterface>) response
{
	self.version = response.Version;
	self.status = response.MultipleMessage;
	self.responseText = response.Response;
	NSMutableDictionary *paramDictionary = [HpsHeartSipSharedParams getInstance].params;
	self.terminalSerialNumber = paramDictionary[@"TERMINAL INFORMATION"][@"SERIAL NUMBER"];
	if (response.ResponseId) {
		self.transactionId =  response.ResponseId.intValue;
	}
	else{
		self.transactionId =  response.TransactionId.intValue;

	}
}

@end
