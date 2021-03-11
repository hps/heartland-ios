#import "HpsGatewayService.h"
#import "HpsServicesConfig.h"
#import "XMLDictionary.h"
#import "HpsTransaction.h"
#import "HpsHeader.h"
#import "HpsPosRequest.h"
#import "HpsGatewayData.h"
#import "HpsTokenData.h"
#import "HpsCommon.h"

@interface HpsGatewayService()
{
    NSString *errorDomain;
}

@property (strong, nonatomic) HpsServicesConfig *config;
@property (nonatomic, strong) NSOperationQueue *queue;

-(BOOL) isConfigInvalid;

@end

@implementation HpsGatewayService

- (id) initWithConfig:(HpsServicesConfig *)config
{
    if(self = [super init])
    {
        self.config = config;
        self.queue = [[NSOperationQueue alloc] init];
        errorDomain = [HpsCommon sharedInstance].hpsErrorDomain;
    }
    
    return self;
}

- (void) doTransaction:(HpsTransaction *)transaction withResponseBlock:(void(^)(HpsGatewayData*, NSError*))responseBlock
{
    if( [self isConfigInvalid] )
    {
      
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Invalid SDK configuration."};
            NSError *error = [NSError errorWithDomain:self->errorDomain
                                         code:ConfigurationError
                                     userInfo:userInfo];
 
            responseBlock(nil, error);
      
        });
        return;
        
    }
    
    HpsHeader *header = [[HpsHeader alloc] init];
    
    if( self.config.secretApiKey )
    {
        header.secretAPIKey = self.config.secretApiKey;
        header.developerID = self.config.developerId;
        header.versionNumber = self.config.versionNumber;
        header.siteTrace = self.config.siteTrace;
        
        if( [self.config.secretApiKey localizedCaseInsensitiveContainsString:@"_prod_"] )
        {
            self.config.serviceUri = @"https://api2-c.heartlandportico.com/Hps.Exchange.PosGateway/PosGatewayService.asmx";
        }
        else
        {
            self.config.serviceUri = @"https://cert.api2-c.heartlandportico.com/Hps.Exchange.PosGateway/PosGatewayService.asmx";
        }
    }
    else
    {
        header.developerID = self.config.developerId;
        header.versionNumber = self.config.versionNumber;
        header.licenseId = self.config.licenseId;
        header.siteId = self.config.siteId;
        header.deviceId = self.config.deviceId;
        header.siteTrace = self.config.siteTrace;
        header.userName = self.config.userName;
        header.password = self.config.password;
        
    }
    
    //Load the POS request
    HpsPosRequest *posRequest = [[HpsPosRequest alloc] init];
    posRequest.header = header;
    posRequest.transaction = transaction;
   
    //Load the http request
    NSString *xmlRequest = [posRequest toXML];
    //NSLog(@"%@",xmlRequest);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.config.serviceUri]];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    NSData *data = [xmlRequest dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [request setValue:[@([data length]) stringValue] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/xml; charset=utf-8;" forHTTPHeaderField:@"Content-Type"];
    
    
    [[NSURLSession sharedSession] dataTaskWithRequest:request
                                    completionHandler:^(NSData *responseData, NSURLResponse *response, NSError *responseError) {
                               
                               if( responseError )
                               {
                                   //error on connection
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [responseError localizedDescription]};
                                       NSError *error = [NSError errorWithDomain:self->errorDomain
                                                                            code:CocoaError
                                                                        userInfo:userInfo];
                                       
                                       responseBlock(nil, error);
                                       
                                   });
                                   return;
                               }
                               
                               @try {
                                   if (responseData != nil){
                                       NSString *responseXML = [[NSString alloc] initWithData:responseData
                                                                                     encoding:NSUTF8StringEncoding];
                                       
                                       NSDictionary *responseDictionary = [NSDictionary dictionaryWithXMLString:responseXML];
                                       
                                       HpsGatewayData *chargeResponse = [[HpsGatewayData alloc] init];
                                       NSDictionary *transactionDictionary = responseDictionary[@"soap:Body"][@"PosResponse"][@"Ver1.0"][@"Transaction"];
                                       NSDictionary *headerDictionary = responseDictionary[@"soap:Body"][@"PosResponse"][@"Ver1.0"][@"Header"];
                                       
                                       if (headerDictionary != nil) {
                                           chargeResponse.gatewayResponseCode = headerDictionary[@"GatewayRspCode"];
                                           chargeResponse.gatewayResponseText = headerDictionary[@"GatewayRspMsg"];
                                           chargeResponse.gatewayTxnId = headerDictionary[@"GatewayTxnId"];
                                           
                                           NSDictionary *tokenData = headerDictionary[@"TokenData"];
                                           if (tokenData != nil) {
                                               chargeResponse.tokenResponse = [[HpsTokenData alloc] init];
                                               chargeResponse.tokenResponse.tokenValue = tokenData[@"TokenValue"];
                                               chargeResponse.tokenResponse.message = tokenData[@"TokenRspMsg"];
                                               chargeResponse.tokenResponse.code = tokenData[@"TokenRspCode"];
                                           }
                                           
                                           if (![chargeResponse.gatewayResponseCode isEqualToString:@"0"]) {
                                               //Failed on Gateway
                                               
                                               NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Failed on issuer. See gatewayResponseCode and gatewayResponseText."};
                                               NSError *error = [NSError errorWithDomain:self->errorDomain
                                                                                    code:IssuerError
                                                                                userInfo:userInfo];
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   responseBlock(chargeResponse, error);
                                               });
                                               
                                               return;
                                           }
                                           
                                       }else{
                                           
                                           //error on header
                                           NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Gateway header is missing."};
                                           NSError *error = [NSError errorWithDomain:self->errorDomain
                                                                                code:GatewayError
                                                                            userInfo:userInfo];
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               responseBlock(nil, error);
                                           });
                                           return;
                                           
                                       }//header
                                   
                                       if (transactionDictionary != nil) {
                                           chargeResponse.referenceNumber = (int) transactionDictionary[@"CreditSale"][@"RefNbr"];
                                           chargeResponse.responseCode = transactionDictionary[@"CreditSale"][@"RspCode"];
                                           chargeResponse.responseText = transactionDictionary[@"CreditSale"][@"RspText"];
                                           chargeResponse.avsResultCode = transactionDictionary[@"CreditSale"][@"AVSRsltCode"];
                                           chargeResponse.avsResultText = transactionDictionary[@"CreditSale"][@"AVSRsltText"];
                                           chargeResponse.authorizationCode = transactionDictionary[@"CreditSale"][@"AuthCode"];
                                           chargeResponse.cardType = transactionDictionary[@"CreditSale"][@"CardType"];
                                           chargeResponse.referenceNumber = (int)transactionDictionary[@"CreditSale"][@"RefNbr"];
                                           
                                           //Error code checking
                                           if (![chargeResponse.responseCode isEqualToString:@"00"]) {
                                               //Failed on issuer
                                               NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Failed on issuer. See responseCode and responseText."};
                                               NSError *error = [NSError errorWithDomain:self->errorDomain
                                                                                    code:IssuerError
                                                                                userInfo:userInfo];
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   responseBlock(chargeResponse, error);
                                               });

                                               return;
                                           }
                                           
                                           //All good
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               responseBlock(chargeResponse, nil);
                                           });
                                           
                                       }else{
                                           
                                           //error
                                           NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Transaction error. See code."};
                                           NSError *error = [NSError errorWithDomain:self->errorDomain
                                                                                code:GatewayError
                                                                            userInfo:userInfo];
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               responseBlock(nil, error);
                                           });
                                         
                                       }//transaction
                                       
                                       
                                   }else{
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"No data returned."};
                                           NSError *error = [NSError errorWithDomain:self->errorDomain
                                                                                code:GatewayError
                                                                            userInfo:userInfo];
                                           responseBlock(nil, error);
                                       });
                                   }
                                   
                               }
                               @catch (NSException *exception) {
                                   //Code runtime error - can happen when no XML is returned - HTML with system error messages.
                                   //or Dictionary parsing on nil errors
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [exception description]};
                                       NSError *error = [NSError errorWithDomain:self->errorDomain
                                                                            code:CocoaError
                                                                        userInfo:userInfo];
                                       
                                       responseBlock(nil, error);
                                       
                                   });
                               }

                           }];    
}

- (BOOL) isConfigInvalid
{
    return  !self.config.secretApiKey &&
    (
      !self.config.deviceId ||
      !self.config.siteId ||
      !self.config.userName ||
      !self.config.password ||
      !self.config.serviceUri
    );
}

@end
