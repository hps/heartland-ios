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
            && self.clientTransactionId);
}

- (BOOL)gmsResponseIsTimeout {
    return ( [self.deviceResponseCode isEqualToString:@"hostTimeout"] || [self.deviceResponseCode containsString:@"Transaction has timed out"]);
}

- (BOOL)gmsResponseOriginalTransactionInvalid {
    return [self.deviceResponseCode containsString:
            @"Transaction rejected because the referenced original transaction is invalid"];
}

- (BOOL)gmsResponseIsDuplicate {
    return [self.deviceResponseCode containsString:@"Transaction was rejected because it is a duplicate"];
}

- (NSString*)gmsResponseDuplicatedTransactionID {
    if(self.gmsResponseIsDuplicate){
        //here is what we expecting:
        //Transaction was rejected because it is a duplicate. Subject '1779929758'.
        NSArray *parts = [self.deviceResponseCode componentsSeparatedByString:@"'"];
        if (parts.count > 0){
            return parts[1];
        }
    }
    return @"";
}

- (void) mapResponse:(id <HpaResposeInterface>) response
{
	self.version = response.Version;
	self.status = response.MultipleMessage;
	self.responseText = response.Response;
    self.issuerRspCode = response.GatewayRspCode;
    self.issuerRspMsg = response.AuthCodeData;
    self.authCode = response.AuthCode;
    self.authCodeData = response.AuthCodeData;
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
