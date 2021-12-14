#import "HpsTerminalResponse.h"
#import "HpsHpaSharedParams.h"
#import <Heartland_iOS_SDK/Heartland_iOS_SDK-Swift.h>

@implementation HpsTerminalResponse

- (BOOL)gmsResponseIsApproval {
    return ([self gmsResponseIsFullApproval]
            || (self.gmsResponseIsReversal
                && self.gmsResponseOriginalTransactionInvalid)
            || [self gmsResponseIsPartialApproval]);
}

- (BOOL)gmsResponseIsFromGateway {
    return self.gmsResponseIsReturn;
}

- (BOOL)gmsResponseIsFullApproval {
    NSString *code = [self gmsResponseIsFromGateway] ? @"Success" : @"APPROVAL";
    return [_deviceResponseCode isEqualToString:code];
}

- (BOOL)gmsResponseIsPartialApproval {
    return [_deviceResponseCode isEqualToString:@"PARTIAL APPROVAL"];
}

- (BOOL)gmsResponseIsReturn {
    return [self.transactionType isEqualToString:@"Return"];
}

- (BOOL)gmsResponseIsReversal {
    return [self.transactionType isEqualToString:@"Reversal"];
}

- (BOOL)gmsResponseIsReversible {
    return (self.gmsResponseIsTimeout
            && !self.gmsResponseIsReversal
            && self.clientTransactionIdUUID);
}

- (BOOL)gmsResponseIsTimeout {
    return [self.deviceResponseCode isEqualToString:@"hostTimeout"];
}

- (BOOL)gmsResponseOriginalTransactionInvalid {
    return [self.deviceResponseCode containsString:
            @"Transaction rejected because the referenced original transaction is invalid"];
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
