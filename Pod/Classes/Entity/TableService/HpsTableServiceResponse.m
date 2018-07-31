#import "HpsTableServiceResponse.h"
#import "HpsServiceContainer.h"

@interface HpsTableServiceResponse()
@end

@implementation HpsTableServiceResponse

-(id)initWithResponseDictionary:(NSDictionary *)responseDictionary{
	if (self = [super initWithResponseDictionary:responseDictionary]){
      _configName = @"default";
	}

	return self;
}

-(void)mapResponse{

	if (!(_expectedAction == nil) && (![self.action isEqualToString:_expectedAction])) {
		@throw [NSException exceptionWithName:@"HpsXMLParsingException" reason:[ NSString stringWithFormat:@"Unexpected message type received. = %@",self.action] userInfo:nil];
	}
}

-(void)sendRequestwithEndPoint:(NSString *)endPoint withMultiPartForm:(NSDictionary *)formData withCompletion:(void(^)(HpsTableServiceResponse *, NSError*))responseBlock
{
	HpsServiceContainer *container  = [HpsServiceContainer sharedInstance] ;
	HpsTableServiceConnector *connector = [container GetTableServiceClient:_configName];

	if (![connector Configured] && ![endPoint isEqualToString:@"/user/login"]) {
		NSLog(@"configName = %@",_configName);
		@throw [NSException exceptionWithName:@"TableService Configuration Exception" reason:[ NSString stringWithFormat:@"Reservation service has not been configured properly. Please ensure you have logged in first."] userInfo:nil];
	}

	[connector callWithEndPoint:endPoint withMultipartForm:formData withCompletion:^(NSDictionary *response_dic, NSError *error) {
	HpsTableServiceResponse *response	= [[HpsTableServiceResponse alloc]initWithResponseDictionary:response_dic];
		responseBlock(response,error);
	}];

}

@end
