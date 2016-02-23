//
//  HpsOrcaService.m
//  Pods
//
//  Created by Shaunti Fondrisi on 2/10/16.
//
//

#import "HpsOrcaService.h"
#import "HpsServicesConfig.h"


@interface HpsOrcaService()
{
    NSString *errorDomain;
}

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSString *serviceURL;

@end

//https://huds.test.e-hps.com

//https://huds.prod.e-hps.com

@implementation HpsOrcaService
- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self.queue = [[NSOperationQueue alloc] init];
    errorDomain = [HpsCommon sharedInstance].hpsErrorDomain;
    
    return self;
}

- (NSString*) setupUrl:(BOOL)isForTesting
{
    if (isForTesting) {
        return @"https://huds.test.e-hps.com/config-server/v1/";
    }else{
        return @"https://huds.prod.e-hps.com/config-server/v1/";
    }
}
- (void) deviceActivationRequest:(HpsDeviceData*)device
                      withConfig:(HpsServicesConfig*)config
                andResponseBlock:(void(^)(HpsDeviceData*, NSError*))responseBlock
{
    
    
    self.serviceURL = [NSString stringWithFormat:@"%@deviceActivation/",[self setupUrl:config.isForTesting]];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.serviceURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60];
    //Auth
    NSData *usernamepwd = [[NSString stringWithFormat:@"%@:%@", config.userName, config.password] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authorization = [NSString stringWithFormat:@"Basic %@", [usernamepwd base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength]];
    
    //Data
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          device.merchantId, @"merchantId",
                          device.deviceId, @"deviceId",
                          device.email, @"email",
                          device.applicationId, @"applicationId",
                          device.hardwareTypeName, @"hardwareTypeName",
                          device.softwareVersion, @"softwareVersion",
                          device.configurationName, @"configurationName",
                          device.peripheralName, @"peripheralName",
                          device.peripheralSoftware, @"peripheralSoftware",
                          nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body
                                                       options:0
                                                         error:nil];
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:authorization forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:self.queue
                           completionHandler:^(NSURLResponse *urlResponse, NSData *responseData, NSError *responseError) {
                               if( responseError )
                               {
                                   //error returned
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [responseError localizedDescription]};
                                       NSError *error = [NSError errorWithDomain:errorDomain
                                                                            code:CocoaError
                                                                        userInfo:userInfo];
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           responseBlock(nil, error);
                                       });
                                       
                                   });
                                   return;
                               }
                               
                               if (responseData != nil){
                                   
                                   NSError *jsonError;
                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                        options:NSJSONReadingAllowFragments
                                                                                          error:&jsonError];
                                   if (jsonError == nil){
                                       if (json[@"message"]) {
                                           
                                           NSError *error = [NSError errorWithDomain:errorDomain
                                                                                code:ServiceError
                                                                            userInfo:json[@"message"]];
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               responseBlock(nil, error);
                                           });
                                           
                                           
                                       }else {
                                           
                                           HpsDeviceData *response = [[HpsDeviceData alloc] init];
                                           response.merchantId = json[@"merchantId"];
                                           response.deviceId = json[@"deviceId"];
                                           response.email = json[@"email"];
                                           response.applicationId = json[@"applicationId"];
                                           response.hardwareTypeName = json[@"hardwareTypeName"];
                                           response.softwareVersion = json[@"softwareVersion"];
                                           response.configurationName = json[@"configurationName"];
                                           response.peripheralName = json[@"peripheralName"];
                                           response.peripheralSoftware = json[@"peripheralSoftware"];
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               responseBlock(response, nil);
                                           });
                                       }
                                       
                                   }else{
                                       NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [jsonError localizedDescription]};
                                       NSError *error = [NSError errorWithDomain:errorDomain
                                                                            code:CocoaError
                                                                        userInfo:userInfo];
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           responseBlock(nil, error);
                                       });
                                   }
                                   
                               }else{
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"No data returned."};
                                       NSError *error = [NSError errorWithDomain:errorDomain
                                                                            code:ServiceError
                                                                        userInfo:userInfo];
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           responseBlock(nil, error);
                                       });
                                   });
                                   
                               }
                               
                           }];
}

- (void) activeDevice:(HpsDeviceData*)device
        withConfig:(HpsServicesConfig*)config
        andResponseBlock:(void(^)(HpsDeviceData*, NSError*))responseBlock
{
    
    self.serviceURL = [NSString stringWithFormat:@"%@deviceActivationKey/",[self setupUrl:config.isForTesting]];
    
    NSString *applicationId = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                            (CFStringRef)device.applicationId,
                                                                                                             NULL,
                                                                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                             kCFStringEncodingUTF8 ));
    
    NSString *activationCode = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                     (CFStringRef)device.activationCode,
                                                                                                     NULL,
                                                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                     kCFStringEncodingUTF8 ));
    
    NSString *getUrl = [NSString stringWithFormat:@"%@?merchantId=%@&applicationId=%@&activationCode=%@", self.serviceURL, device.merchantId, applicationId, activationCode];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getUrl]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:self.queue
                           completionHandler:^(NSURLResponse *urlResponse, NSData *responseData, NSError *responseError) {
                               if( responseError )
                               {
                                   //error returned
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [responseError localizedDescription]};
                                       NSError *error = [NSError errorWithDomain:errorDomain
                                                                            code:CocoaError
                                                                        userInfo:userInfo];
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           responseBlock(nil, error);
                                       });
                                       
                                   });
                                   return;
                               }
                               
                               if (responseData != nil){
                                   
                                   NSError *jsonError;
                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                        options:NSJSONReadingAllowFragments
                                                                                          error:&jsonError];
                                   if (jsonError == nil){
                                       if (json[@"message"]) {
                                           
                                           NSError *error = [NSError errorWithDomain:errorDomain
                                                                                code:ServiceError
                                                                            userInfo:json[@"message"]];
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               responseBlock(nil, error);
                                           });
                                           
                                           
                                       }else {
                                           HpsDeviceData *response = [[HpsDeviceData alloc] init];
                                           response.merchantId = json[@"merchantId"];
                                           response.applicationId = json[@"applicationId"];
                                           response.activationCode = json[@"activationCode"];
                                           response.deviceId = json[@"deviceId"];
                                           response.apiKey = json[@"apiKey"];
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               responseBlock(response, nil);
                                           });

                                       }
                                       
                                   }else{
                                       NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [jsonError localizedDescription]};
                                       NSError *error = [NSError errorWithDomain:errorDomain
                                                                            code:CocoaError
                                                                        userInfo:userInfo];
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           responseBlock(nil, error);
                                       });

                                       
                                   }
                                   
                                   
                                   
                               }else{
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"No data returned."};
                                       NSError *error = [NSError errorWithDomain:errorDomain
                                                                            code:ServiceError
                                                                        userInfo:userInfo];
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           responseBlock(nil, error);
                                       });
                                   });
                                   
                               }
                               
                           }];
}



- (void) getDeviceAPIKey:(HpsServicesConfig*)config
        andResponseBlock:(void(^)(NSString*, NSError*))responseBlock
{
    
    self.serviceURL = [NSString stringWithFormat:@"%@deviceApiKey/",[self setupUrl:config.isForTesting]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.serviceURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60];
    
    NSData *usernamepwd = [[NSString stringWithFormat:@"%@:%@", config.userName, config.password] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authorization = [NSString stringWithFormat:@"Basic %@", [usernamepwd base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength]];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:authorization forHTTPHeaderField:@"Authentication"];
    [request addValue:config.siteId forHTTPHeaderField:@"siteId"];
    [request addValue:config.licenseId forHTTPHeaderField:@"licenseId"];
    [request addValue:config.deviceId forHTTPHeaderField:@"deviceId"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:self.queue
                           completionHandler:^(NSURLResponse *urlResponse, NSData *responseData, NSError *responseError) {
                               if( responseError )
                               {
                                   //error returned
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [responseError localizedDescription]};
                                       NSError *error = [NSError errorWithDomain:errorDomain
                                                                            code:CocoaError
                                                                        userInfo:userInfo];
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           responseBlock(nil, error);
                                       });
                                       
                                   });
                                   return;
                               }
                               
                               if (responseData != nil){
                                   
                                   NSError *jsonError;
                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                        options:NSJSONReadingAllowFragments
                                                                                          error:&jsonError];
                                   if (jsonError == nil){
                                       
                                       if (json[@"message"]) {
                                           
                                           NSError *error = [NSError errorWithDomain:errorDomain
                                                                                code:ServiceError
                                                                            userInfo:json[@"message"]];
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               responseBlock(nil, error);
                                           });
                                           

                                       }else {
                                           NSString *apiKey = json[@"apiKey"];
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               responseBlock(apiKey, nil);
                                           });
                                       }
                                       
                                   }else{
                                       NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [jsonError localizedDescription]};
                                       NSError *error = [NSError errorWithDomain:errorDomain
                                                                            code:ServiceError
                                                                        userInfo:userInfo];
                                       
                                       responseBlock(nil, error);
                                   }
                               }else{
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"No data returned."};
                                       NSError *error = [NSError errorWithDomain:errorDomain
                                                                            code:ServiceError
                                                                        userInfo:userInfo];
                                       responseBlock(nil, error);
                                   });
                               }
                               
                           }];
}


- (void) getDeviceParameters:(HpsDeviceData*)device
                  withConfig:(HpsServicesConfig*)config
            andResponseBlock:(void(^)(NSDictionary*, NSError*))responseBlock
{
    
    self.serviceURL = [NSString stringWithFormat:@"%@deviceParameters",[self setupUrl:config.isForTesting]];
    NSData *key = [[NSString stringWithFormat:@"%@:", config.secretApiKey] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedKey = [key base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
    
    NSString *authentication = [NSString stringWithFormat:@"Basic %@", encodedKey];
    
    //urlencoded
    NSString *applicationId = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                    (CFStringRef)device.applicationId,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 ));
    //urlencoded
    NSString *hardwareType = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                     (CFStringRef)device.hardwareTypeName,
                                                                                                     NULL,
                                                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                     kCFStringEncodingUTF8 ));
    
    NSString *getUrl = [NSString stringWithFormat:@"%@?deviceId=%@&applicationId=%@&hardwareTypeName=%@", self.serviceURL, device.deviceId, applicationId, hardwareType];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getUrl]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60];
    
    [request addValue:authentication forHTTPHeaderField:@"Authentication"];

    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:self.queue
                           completionHandler:^(NSURLResponse *urlResponse, NSData *responseData, NSError *responseError) {
                               if( responseError )
                               {
                                   //error returned
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [responseError localizedDescription]};
                                       NSError *error = [NSError errorWithDomain:errorDomain
                                                                            code:CocoaError
                                                                        userInfo:userInfo];
                                       
                                       responseBlock(nil, error);
                                       
                                   });
                                   return;
                               }
                               
                               if (responseData != nil){
                                   
                                   NSError *jsonError;
                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                        options:NSJSONReadingAllowFragments
                                                                                          error:&jsonError];
                                   
                                   if (jsonError == nil){
                                       if (json[@"message"]) {
                                           NSError *error = [NSError errorWithDomain:errorDomain
                                                                                code:ServiceError
                                                                            userInfo:json[@"message"]];
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               responseBlock(nil, error);
                                           });
                                           
                                       }else {
                                           
                                           //Success
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               responseBlock(json, nil);
                                           });
                                       }
                                       
                                   }else{
                                       NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [jsonError localizedDescription]};
                                       NSError *error = [NSError errorWithDomain:errorDomain
                                                                            code:CocoaError
                                                                        userInfo:userInfo];
                                       
                                       responseBlock(nil, error);
                                   }//json error
                                   
                               }else{
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"No data returned."};
                                       NSError *error = [NSError errorWithDomain:errorDomain
                                                                            code:GatewayError
                                                                        userInfo:userInfo];
                                       responseBlock(nil, error);
                                   });
                                   
                               }//response data != nil
                               
                           }];
}

@end
