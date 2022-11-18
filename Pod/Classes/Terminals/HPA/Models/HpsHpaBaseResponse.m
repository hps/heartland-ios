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
	self.recievedResponse = response;
	self.response = response.Response;

	self.ecrId = response.ECRId;
	self.hpaId = response.SIPId;
	self.version = response.Version;
	self.status = response.MultipleMessage;

	if (self.recievedResponse.ResponseText)
		{
		self.deviceResponseMessage = self.recievedResponse.ResponseText;

		}
	else{
		self.deviceResponseMessage = self.recievedResponse.ResultText;

	}
	if (self.recievedResponse.ResponseCode)
		{
		self.deviceResponseCode = [self NormalizeResponse:self.recievedResponse.ResponseCode];
		}
	else
		{
		self.deviceResponseCode = [self NormalizeResponse:self.recievedResponse.Result] ;
		}
    
    if (self.recievedResponse.GatewayRspCode) {
        self.issuerRspCode = [self NormalizeResponse:self.recievedResponse.GatewayRspCode];
    }
    
    if (self.recievedResponse.GatewayRspMsg) {
        self.issuerRspMsg = [self NormalizeResponse:self.recievedResponse.GatewayRspMsg];
    }
    
    if (self.recievedResponse.AuthCode) {
        self.authCode = [self NormalizeResponse:self.recievedResponse.AuthCode];
    }
    
    if (self.recievedResponse.AuthCodeData) {
        self.authCodeData = [self NormalizeResponse:self.recievedResponse.AuthCodeData];
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

