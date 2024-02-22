#import "HpsPaxHttpInterface.h"
#import "HpsCommon.h"

@interface HpsPaxHttpInterface()
{
     NSString *errorDomain;
}

@property (strong, nonatomic) NSURLSessionDataTask *pendingTask;

@end

@implementation HpsPaxHttpInterface

- (instancetype) initWithConfig:(HpsConnectionConfig*)config
{
    if((self = [super init]))
    {
        self.config = config;
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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:160];
  
    NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithRequest:request
                                                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                  {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setPendingTask:nil];
            
            if (error) {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [error localizedDescription],
                                           @"URLResponseErrorCodeKey": @(error.code)};
                NSError *error = [NSError errorWithDomain:self->errorDomain
                                                     code:CocoaError
                                                 userInfo:userInfo];
                
                responseBlock(nil, error);
                
                return;
            }
            
            if (data) {
                responseBlock(data, nil);
            } else {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"No data returned."};
                NSError *miscError = [NSError errorWithDomain:self->errorDomain
                                                         code:GatewayError
                                                     userInfo:userInfo];
                responseBlock(nil, miscError);
            }
        });
    }];
    
    _pendingTask = task;
    
    [task resume];
}

- (void)cancelPendingTask {
    if (_pendingTask) {
        [_pendingTask cancel];
    }
}
@end
