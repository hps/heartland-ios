#import "HpsRestGateway.h"

@interface HpsRestGateway()
@property (nonatomic,strong) HpsGateway* hpsGateway;
@end

@implementation HpsRestGateway

-(id)init {

	self = [super init];

	self.headers = [NSMutableDictionary new];

	self.hpsGateway = [[HpsGateway alloc] initWithGateway:@"application/json"];

	return self;
}

-(void)setServiceUrl:(NSString *)serviceUrl {
	_serviceUrl = serviceUrl;
	self.hpsGateway.serviceUrl = _serviceUrl;
}

-(void)setTimeOut:(NSInteger)timeOut {
	_timeOut = timeOut;
	self.hpsGateway.timeOut = _timeOut;
}

-(void)doTransaction:(NSString*)httpMethod endPoint:(NSString*)endPoint data:(NSString*)data andQueryParams:(NSDictionary*)params handler:(void (^)(NSString* response, NSError* error))responseBlock {

	self.hpsGateway.headers = self.headers;
    
    [self.hpsGateway sendRequest:@"POST" endPoint:endPoint data:data queryParams:params handler:^(HpsGatewayResponse *gatewayObject, NSError *error) {
        
        responseBlock([self handleResponse:gatewayObject],error);
    }];
    
}

-(NSString*)handleResponse:(HpsGatewayResponse*)response {
    
    if (response.statusCode != 200) {
        
        HpsJsonDoc* doc = [[[HpsJsonDoc alloc] init] parse:response.rawResponse withEncoder:nil];
        HpsJsonDoc* doc2 = [doc get:@"error"];
        
        @throw [NSException exceptionWithName:@"HpsPayrollException" reason:[NSString stringWithFormat:@"Status Code: %ld - %@", (long)response.statusCode, [doc2 getValue:@"message"]] userInfo:nil];
    }
    return response.rawResponse;
}


@end
