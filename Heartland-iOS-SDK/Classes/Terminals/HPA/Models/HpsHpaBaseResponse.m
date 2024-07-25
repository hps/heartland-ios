#import "HpsHpaBaseResponse.h"
#import "HpsHpaParser.h"

@interface HpsHpaBaseResponse()

@end

@implementation HpsHpaBaseResponse

-(id)initWithHpaBaseResponse:(NSData *)data withParameters:(NSArray *)messageIds
{
	if(self = [super init])
		{
			//id <HpaResposeInterface> responeP = [HpsHpaParser parseResponse:data] ;
		NSString *xmlString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
			//NSArray *ar = [xmlString componentsSeparatedByString:[HpsTerminalEnums controlCodeString:HpsControlCodes_FS]];
		id <HpaResposeInterface> responeN = [HpsHpaParser parseResponseWithXmlString:xmlString] ;
		
		[self mapResponse:responeN];
		}

	return self;
}

- (void) mapResponse:(id <HpaResposeInterface>) response{
	[super mapResponse:response];
	self.receivedResponse = response;
	self.response = response.Response;

	self.ecrId = response.ECRId;
	self.hpaId = response.SIPId;
	self.version = response.Version;
	self.status = response.MultipleMessage;

	if (self.receivedResponse.ResponseText)
		{
		self.deviceResponseMessage = self.receivedResponse.ResponseText;

		}
	else{
		self.deviceResponseMessage = self.receivedResponse.ResultText;

	}
	if (self.receivedResponse.ResponseCode)
		{
		self.deviceResponseCode = [self NormalizeResponse:self.receivedResponse.ResponseCode];
		}
	else
		{
		self.deviceResponseCode = [self NormalizeResponse:self.receivedResponse.Result] ;
		}
    
    if (self.receivedResponse.GatewayRspCode) {
        self.issuerRspCode = self.receivedResponse.GatewayRspCode;
    }
    
    if (self.receivedResponse.GatewayRspMsg) {
        self.issuerRspMsg = self.receivedResponse.GatewayRspMsg;
    }
    
    if (self.receivedResponse.AuthCode) {
        self.authCode = [self NormalizeResponse:self.receivedResponse.AuthCode];
    }
    
    if (self.receivedResponse.AuthCodeData) {
        self.authCodeData = [self NormalizeResponse:self.receivedResponse.AuthCodeData];
    }
    
    if (self.receivedResponse.SurchargeAmount) {
        self.surchargeAmount = [self NormalizeResponse:self.receivedResponse.SurchargeAmount];
    }
    
    if (self.receivedResponse.SurchargeFee) {
        self.surchargeFee = [self NormalizeResponse:self.receivedResponse.SurchargeFee];
    }
    
    if (self.receivedResponse.SurchargeRequested) {
        self.surchargeRequested = self.receivedResponse.SurchargeRequested;
    }
}

-(NSString *)NormalizeResponse:(NSString *)response
{
	NSArray *acceptedCodes = @[@"0" ,@"85"];
	if([acceptedCodes containsObject:response]){
		return @"00";
	}
	return response;
}

-(NSString *)toString{
	return _response;
}

@end

