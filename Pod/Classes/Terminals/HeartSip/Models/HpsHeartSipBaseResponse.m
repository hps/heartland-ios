#import "HpsHeartSipBaseResponse.h"
#import "HpsHeartSipParser.h"

@interface HpsHeartSipBaseResponse()

@end

@implementation HpsHeartSipBaseResponse

-(id)initWithHeartSipBaseResponse:(NSData *)data withParameters:(NSArray *)messageIds
{
	if(self = [super init])
		{
			//id <SipResposeInterface> responeP = [HpsHeartSipParser parseResponse:data] ;
		NSString *xmlString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
			//NSArray *ar = [xmlString componentsSeparatedByString:[HpsTerminalEnums controlCodeString:HpsControlCodes_FS]];
		id <SipResposeInterface> responeN = [HpsHeartSipParser parseResponseWithXmlString:xmlString] ;
		
		[self mapResponse:responeN];
		}

	return self;
}

- (void) mapResponse:(id <SipResposeInterface>) response{
	[super mapResponse:response];
	self.recievedResponse = response;
	self.response = response.Response;

	self.ecrId = response.ECRId;
	self.sipId = response.SIPId;
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

