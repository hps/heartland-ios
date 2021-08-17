#import "HpsTerminalResponse.h"
#import "HpsHpaSharedParams.h"

@implementation HpsTerminalResponse

- (void) mapResponse:(id <HpaResposeInterface>) response
{
	self.version = response.Version;
	self.status = response.MultipleMessage;
	self.responseText = response.Response;
	NSMutableDictionary *paramDictionary = [HpsHpaSharedParams getInstance].params;
	self.terminalSerialNumber = paramDictionary[@"TERMINAL INFORMATION"][@"SERIAL NUMBER"];
	if (response.ResponseId) {
		self.transactionId =  response.ResponseId;
	}
	else{
		self.transactionId =  response.TransactionId;

	}
}

@end
