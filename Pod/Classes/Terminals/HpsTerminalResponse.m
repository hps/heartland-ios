#import "HpsTerminalResponse.h"
#import "HpsHpaSharedParams.h"
#import <Heartland_iOS_SDK/Heartland_iOS_SDK-Swift.h>

@implementation HpsTerminalResponse

- (BOOL)isApproval {
    return [self.deviceResponseCode isEqualToString:@"APPROVAL"];
}

- (BOOL)gmsResponseIsTimeout {
    return [self.deviceResponseCode isEqualToString:@"hostTimeout"];
}

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
    self.lastResponseTransactionId = [HpsHpaSharedParams getInstance].lastResponse.ResponseId;
    
}

@end
