//
//  HpsService.m
//  SecureSubmit
//
//  Created by Roberts, Jerry on 7/21/14.
//  Copyright (c) 2014 Heartland Payment Systems. All rights reserved.
//

#import "HpsGatewayService.h"
#import "HpsServicesConfig.h"
#import "XMLDictionary.h"
#import "HpsTransaction.h"
#import "HpsHeader.h"
#import "HpsPosRequest.h"
#import "HpsGatewayResponse.h"
#import "HpsTokenResponse.h"

@interface HpsGatewayService()

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
    }
    
    return self;
}

- (void) doTransaction:(HpsTransaction *)transaction withResponseBlock:(void(^)(HpsGatewayResponse*))responseBlock
{
    if( [self isConfigInvalid] )
    {
        // TODO: throw sdk exception
        
        
        
        
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
            self.config.serviceUri = @"https://posgateway.secureexchange.net/Hps.Exchange.PosGateway/PosGatewayService.asmx";
        }
        else
        {
            self.config.serviceUri = @"https://cert.api2.heartlandportico.com/Hps.Exchange.PosGateway/PosGatewayService.asmx";
        }
    }
    else
    {
        header.developerID = self.config.developerId;
        header.versionNumber = self.config.versionNumber;
        header.siteTrace = self.config.siteTrace;
        header.licenseId = self.config.licenseId;
        header.siteId = self.config.siteId;
        header.deviceId = self.config.deviceId;
        header.siteTrace = self.config.siteTrace;
        header.siteTrace = self.config.userName;
        header.siteTrace = self.config.password;
        
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
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:self.queue
                           completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *responseError) {
                               if( responseError )
                               {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       HpsGatewayResponse *chargeResponse = [[HpsGatewayResponse alloc] init];
                                       chargeResponse.responseCode = [@(responseError.code) stringValue];
                                       chargeResponse.responseText = [responseError localizedDescription];
                                       responseBlock(chargeResponse);
                                       return;
                                   });
                               }
                               
                               if (responseData != nil){
                                   NSString *responseXML = [[NSString alloc] initWithData:responseData
                                                                                 encoding:NSUTF8StringEncoding];
                                   
                                   NSDictionary *responseDictionary = [NSDictionary dictionaryWithXMLString:responseXML];
                                   
                                   //NSLog(@"%@",[responseDictionary description]);
                                   
                                   HpsGatewayResponse *chargeResponse = [[HpsGatewayResponse alloc] init];
                                   NSDictionary *transactionDictionary = responseDictionary[@"soap:Body"][@"PosResponse"][@"Ver1.0"][@"Transaction"];
                                   
                                   if (transactionDictionary != nil) {
                                       chargeResponse.referenceNumber = transactionDictionary[@"CreditSale"][@"RefNbr"];
                                       chargeResponse.responseCode = transactionDictionary[@"CreditSale"][@"RspCode"];
                                       chargeResponse.responseText = transactionDictionary[@"CreditSale"][@"RspText"];
                                       chargeResponse.avsResultCode = transactionDictionary[@"CreditSale"][@"AVSRsltCode"];
                                       chargeResponse.avsResultText = transactionDictionary[@"CreditSale"][@"AVSRsltText"];
                                       chargeResponse.authorizationCode = transactionDictionary[@"CreditSale"][@"AuthCode"];
                                       chargeResponse.cardType = transactionDictionary[@"CreditSale"][@"CardType"];
                                       chargeResponse.referenceNumber = transactionDictionary[@"CreditSale"][@"RefNbr"];
                                       
                                       NSDictionary *tokenData = responseDictionary[@"soap:Body"][@"PosResponse"][@"Ver1.0"][@"Header"][@"TokenData"];
                                       if (tokenData != nil) {
                                           chargeResponse.tokenResponse = [[HpsTokenResponse alloc] init];
                                           chargeResponse.tokenResponse.tokenValue = tokenData[@"TokenValue"];
                                           chargeResponse.tokenResponse.message = tokenData[@"TokenRspMsg"];
                                           chargeResponse.tokenResponse.code = tokenData[@"TokenRspCode"];
                                       }

                                   }else{
                                       //error
                                       NSDictionary *headerDictionary = responseDictionary[@"soap:Body"][@"PosResponse"][@"Ver1.0"][@"Header"];
                                       chargeResponse.responseCode = headerDictionary[@"GatewayRspCode"];
                                       chargeResponse.responseText = headerDictionary[@"GatewayRspMsg"];
                                       
                                       
                                   }
                                    //chargeResponse.cardNumber   - not seeing this in the response
                                   
                                   
                                   // TODO: advanced error handling
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       responseBlock(chargeResponse);
                                       return;
                                   });

                               }else{
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       HpsGatewayResponse *chargeResponse = [[HpsGatewayResponse alloc] init];
                                       chargeResponse.responseCode = @"01";
                                       chargeResponse.responseText = @"No data returned";
                                       responseBlock(chargeResponse);
                                       return;
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
