#import "HpsTableServiceConnector.h"
#import "XMLDictionary.h"

@import MobileCoreServices;

@implementation HpsTableServiceConnector

-(Boolean) Configured {
	if (self.locationId && self.sessionId && self.securityToken) {
		return YES;
	}
	else{
		return NO;
	}
}

-(id)init{
	if(self = [super init]){
		NSLog(@"** Connector Initialised");
	}
	return self;
}


-(void) callWithEndPoint:(NSString *) endpoint withMultipartForm:(NSDictionary *) content withCompletion:(void(^)(NSDictionary *, NSError*))responseBlock {
	NSMutableDictionary *bodycontent = [[NSMutableDictionary alloc]initWithDictionary:content];
	if (self.locationId && self.securityToken && self.sessionId) {
		[bodycontent setValue:self.locationId forKey:@"locID"];
		[bodycontent setValue:self.securityToken forKey:@"token"];
		[bodycontent setValue:self.sessionId forKey:@"sessionID"];

	}

	[self sendRequestWithEndPoint:endpoint withContent:bodycontent withCompletion:^(NSData *data, NSError *error) {

		if (error) {
			responseBlock(nil,error);
		}
		else {
			NSString * responseXML = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
			NSDictionary *responseDictionary = [NSDictionary dictionaryWithXMLString:responseXML];

			if ([responseDictionary[@"data"][@"row"] isKindOfClass:[NSArray class]]) {
					//NSLog(@"**** Did nothing with array");
			}
			else
			{
			if (responseDictionary[@"data"][@"row"][@"locID"] ) {
				self.locationId = responseDictionary[@"data"][@"row"][@"locID"];
			}else if(responseDictionary[@"data"][@"row"][@"sessionID"]){
				self.sessionId = responseDictionary[@"data"][@"row"][@"sessionID"];
				self.sessionId = @"10101";
			}else if(responseDictionary[@"data"][@"row"][@"token"]){
				self.securityToken = responseDictionary[@"data"][@"row"][@"token"];

			}else if(responseDictionary[@"data"][@"row"][@"tableStatus"]){
							 self.bupStatusCollection = [[HpsBumpStatusCollection alloc]
														 initWithBumpStatusCollectoion:responseDictionary[@"data"][@"row"][@"tableStatus"]];
			}
			}
			responseBlock(responseDictionary,nil);
		}
	}];

}



-(NSMutableData *)getRequestBody:(NSDictionary *)dic{
	NSMutableData *body = [NSMutableData data];
 NSString *boundary = @"14737809831466499882746641449";

	for (NSString* key in dic) {
		id value = [dic objectForKey:key];
		NSLog(@"value = %@",value);
		NSLog(@"key = %@",key);

		[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"%@", value] dataUsingEncoding:NSUTF8StringEncoding]];
	}


	return body;
}
-(void)sendRequestWithEndPoint:(NSString *)endPoint withContent:(NSDictionary *)contents withCompletion:(void(^)(NSData*, NSError*))responseBlock{

	NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
	NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
	NSURL * url = [NSURL URLWithString:[ NSString stringWithFormat:@"https://www.freshtxt.com/api31%@",endPoint]];;
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
														   cachePolicy:NSURLRequestUseProtocolCachePolicy
													   timeoutInterval:60.0];

 NSString *boundary = @"14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
		[request addValue:contentType forHTTPHeaderField: @"Content-Type"];



	[request setHTTPMethod:@"POST"];

	[request setHTTPBody:[self getRequestBody:contents]];


	NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)

										  {

										  if(error == nil)
											  {
											  NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
											  NSLog(@"Data = %@",text);
											  responseBlock(data,nil);
											  }else{
												  responseBlock(nil,error);

											  }

										  }];
	
	[postDataTask resume];

}

@end
