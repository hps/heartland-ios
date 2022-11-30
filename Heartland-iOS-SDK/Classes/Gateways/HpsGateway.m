#import "HpsGateway.h"

@interface HpsGateway()

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, readwrite) NSString *contentType;

@end

@implementation HpsGateway

-(id)initWithGateway:(NSString*)contentType {
	if (self = [super init]) {
		_headers = [[NSMutableDictionary alloc] init];
		_contentType = contentType;
	}
	return self;
}

-(void)sendRequest:(NSString*)httpMethod endPoint:(NSString*)endpoint data:(NSString*)data queryParams:(NSDictionary*)params handler:(void(^)(HpsGatewayResponse *gatewayObject, NSError* error))responseBlock {

	NSString* queryString = [self buildQueryString:params];
	NSString*strURL = [NSString stringWithFormat:@"%@%@%@",self.serviceUrl,endpoint,queryString];
	NSMutableURLRequest *request  = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.00];

	[request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setHTTPMethod:httpMethod];

	for (NSString* key in _headers.allKeys) {
			//passing key as a http header request
		[request addValue:[_headers objectForKey:key] forHTTPHeaderField:key];
	}

	if (data != nil)
		[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];

	__block HpsGatewayResponse *gatewayResponse = [[HpsGatewayResponse alloc] init];

	dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

	NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
	NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];

	NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

		NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;

		NSString *responseString = [[NSString alloc] initWithData:data
														 encoding:NSUTF8StringEncoding];
		gatewayResponse.statusCode = httpResponse.statusCode;
		gatewayResponse.rawResponse = responseString;
		gatewayResponse.requestUrl = response.URL.absoluteString;

		responseBlock(gatewayResponse,error);

		dispatch_semaphore_signal(semaphore);
	}];

	[postDataTask resume];

	dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

}

-(void)sendRequestWithEndPoint:(NSString *)endPoint withMultiPart:(NSDictionary *)content handler:(void(^)(HpsGatewayResponse *gatewayObject, NSError* error))responseBlock {

	NSMutableURLRequest *request  = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[_serviceUrl stringByAppendingString:endPoint]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.00];
	[request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setHTTPMethod:@"POST"];

	__block HpsGatewayResponse *gatewayResponse = [[HpsGatewayResponse alloc] init];

	NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
	NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];

	NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

		NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;

		NSString *responseString = [[NSString alloc] initWithData:data
														 encoding:NSUTF8StringEncoding];
		gatewayResponse.statusCode = httpResponse.statusCode;
		gatewayResponse.rawResponse = responseString;
		gatewayResponse.requestUrl = response.URL.absoluteString;

		responseBlock(gatewayResponse,error);

	}];

	[postDataTask resume];

}

-(NSString*)buildQueryString:(NSDictionary*)params {

	if(params == nil) {
		return nil;
	}

	NSString* strQuery = @"";

	if (params.allKeys.count>0) {

		NSString* str = @"?";

		for (NSString* key in params.allKeys) {

			if (key == params.allKeys.firstObject) {
				str = [str stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,[params objectForKey:key]]];
			}else {
				str = [str stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key,[params objectForKey:key]]];
			}
		}

		strQuery = [NSString stringWithString:str];
	}

	return strQuery;
}

@end
