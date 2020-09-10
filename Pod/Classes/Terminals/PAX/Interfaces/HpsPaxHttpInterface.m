#import "HpsPaxHttpInterface.h"
#import "HpsCommon.h"

@interface HpsPaxHttpInterface()
{
     NSString *errorDomain;
}

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation HpsPaxHttpInterface

- (instancetype) initWithConfig:(HpsConnectionConfig*)config
{
    if((self = [super init]))
    {
        self.config = config;
        self.queue = [[NSOperationQueue alloc] init];
        errorDomain = [HpsCommon sharedInstance].hpsErrorDomain;
    }
    return self;
}

-(void) connect{
    //not used in http
}
-(void) disconnect{
    
}
-(void) send:(id<IHPSDeviceMessage>)message andResponseBlock:(void(^)(NSData*, NSError*))responseBlock{
	NSLog(@"\r Request_toString = %@ \r",message.toString);


    NSData *data = [message getSendBuffer];
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%@/?%@",
                           self.config.ipAddress,
                           self.config.port,
                           [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
    
    NSLog(@"181189=%@",urlString);
    [[MBLogger sharedInstance] sysLog:[NSString stringWithFormat:@"PAX request url: %@",urlString] fromClass:[self class] calledBy:_cmd];
    [[MBLogger sharedInstance] sysLog:[NSString stringWithFormat:@"PAX request: %@", message.toString] fromClass:[self class] calledBy:_cmd];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:160];
  
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:self.queue
                           completionHandler:^(NSURLResponse *urlResponse, NSData *responseData, NSError *responseError) {
                               
                               if( responseError )
                               {
                                   //error returned
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [responseError localizedDescription],
                                                                  @"URLResponseErrorCodeKey": @(responseError.code)};
                                       NSError *error = [NSError errorWithDomain:self->errorDomain
                                                                            code:CocoaError
                                                                        userInfo:userInfo];
                                       
                                       responseBlock(nil, error);
                                       
                                   });
                                   return;
                               }
                               
                               if (responseData != nil){
                                   //Success
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       responseBlock(responseData, nil);
                                   });
                               }else{
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"No data returned."};
                                       NSError *error = [NSError errorWithDomain:self->errorDomain
                                                                            code:GatewayError
                                                                        userInfo:userInfo];
                                       responseBlock(nil, error);
                                   });
                               }//response data != nil
                               
                           }];
    
  
}

@end
