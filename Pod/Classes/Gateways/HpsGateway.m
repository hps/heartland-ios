//
//  HpsGateway.m
//  Pods
//
//  Created by anurag sharma on 04/04/18.
//
//

#import "HpsGateway.h"
@interface HpsGateway(){

}
@property (nonatomic, strong) NSOperationQueue *queue;
@property (readwrite) NSString *contentType;

@end

@implementation HpsGateway


-(id)initWithGateway:(NSString *)contentType{
	if (self = [super init]) {
		_headers = [[NSMutableDictionary alloc]init];
		_contentType = contentType;
	}
	return self;
}

-(void)sendRequestWithEndPoint:(NSString *)endPoint withMultiPart:(NSDictionary *)content withResponseBlock:(void(^)(HpsGatewayResponse *, NSError*))responseBlock{

//	NSURLRequest *request  = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[_serviceUrl stringByAppendingString:endPoint]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.00];
//	
//[NSURLConnection sendAsynchronousRequest:request queue:_queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//	HpsGatewayResponse *gatwayResponse = [[HpsGatewayResponse alloc]init];
//	NSString  *responseString = [[NSString alloc] initWithData:data
//						  encoding:NSUTF8StringEncoding];
//		//gatwayResponse.statusCode = gatew;
//		//gatwayResponse.rawResponseCode = ;
//
//	responseBlock(gatwayResponse,nil);
//}];

}

@end
