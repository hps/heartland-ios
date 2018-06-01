//
//  TokenService.m
//  Heartland-Tokenization
//
//  Created by Roberts, Jerry on 2/2/15.
//  Copyright (c) 2015 Heartland Payment Systems. All rights reserved.
//

#import "HpsTokenService.h"
#import "HpsTokenData.h"

typedef void(^CallbackBlock)(HpsTokenData*);

@interface HpsTokenService() <NSURLConnectionDelegate>

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSString *publicKey;
@property (nonatomic, strong) NSString *serviceURL;

@property (nonatomic) CallbackBlock responseBlock;

@end

@implementation HpsTokenService

- (id) initWithPublicKey:(NSString *)publicKey
{
    if((self = [super init]))
    {
        self.publicKey = publicKey;
        self.queue = [[NSOperationQueue alloc] init];
        
        if(!publicKey)
        {
            [NSException raise:NSInvalidArgumentException format:@"publicKey can not be nil"];
        }
        
        NSArray *components = [self.publicKey componentsSeparatedByString:@"_"];
        NSString *env = [components[1] lowercaseString];
        
        if([env isEqual:@"prod"]) {
            self.serviceURL = @"https://api2.heartlandportico.com/SecureSubmit.v1/api/token";
        }
        else if ([env isEqualToString:@"cert"]) {
            self.serviceURL = @"https://cert.api2.heartlandportico.com/Hps.Exchange.PosGateway.Hpf.v1/api/token";
        }
        else {
            self.serviceURL = @"http://gateway.e-hps.com/Hps.Exchange.PosGateway.Hpf.v1/api/token";
            //[NSException raise:NSInvalidArgumentException format:@"publicKey unrecognized environment"];
        }
        
    }
    return self;
}

- (void) getTokenWithCardNumber:(NSString*)cardNumber
                            cvc:(NSString*)cvc
                       expMonth:(NSString*)expMonth
                        expYear:(NSString*)expYear
               andResponseBlock:(void(^)(HpsTokenData*))responseBlock
{
    self.responseBlock = responseBlock;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.serviceURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60];
    
    NSData *apiKey = [[NSString stringWithFormat:@"%@:", self.publicKey] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *authorization = [NSString stringWithFormat:@"Basic %@", [apiKey base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    
    NSDictionary *card = [NSDictionary dictionaryWithObjectsAndKeys:
                          cardNumber, @"number",
                          cvc, @"cvc",
                          expMonth, @"exp_month",
                          expYear, @"exp_year", nil];
    
    NSDictionary *token = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"token", @"object",
                           @"supt", @"token_type",
                           card, @"card", nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:token
                                                       options:0
                                                         error:nil];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:authorization forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[@([jsonData length]) stringValue] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonData];
    
    NSURLConnection *connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

// NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (data != nil){
        
        
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:&jsonError];
        if (jsonError != nil){
            
            HpsTokenData *response = [[HpsTokenData alloc] init];
            response.code = [@(jsonError.code) stringValue];
            response.message = [jsonError localizedDescription];
            response.type = @"error";
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.responseBlock(response);
            });
            
        }
        
        HpsTokenData *response = [[HpsTokenData alloc] init];
        
        if(json[@"error"])
        {
            response.code = json[@"error"][@"code"];
            response.message = json[@"error"][@"message"];
            response.param = json[@"error"][@"param"];
            response.type = @"error";
        }
        else
        {
            response.tokenValue = json[@"token_value"];
            response.tokenType = json[@"token_type"];
            response.tokenExpire = json[@"token_expire"];
            response.cardNumber = json[@"card"][@"number"];
            response.type = @"token";
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.responseBlock(response);
            
        });
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (error != nil){
        
        HpsTokenData *response = [[HpsTokenData alloc] init];
        response.code = [@(error.code) stringValue];
        response.message = [error localizedDescription];
        response.type = @"error";
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.responseBlock(response);
        });
        
    }
}

-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    // get the public key offered by the server
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    SecKeyRef actualKey = SecTrustCopyPublicKey(serverTrust);
    
    // load the reference certificates
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSArray *dirFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSArray *certFiles = [dirFiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.cer'"]];
    
    BOOL isMatch = false;
    
    for (NSString *certFile in certFiles) {
        NSString *certPath = [NSString stringWithFormat:@"%@/%@", path, certFile];
        NSData* certData = [NSData dataWithContentsOfFile: certPath];
        SecCertificateRef expectedCertificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certData);
        
        // extract the expected public key
        SecKeyRef expectedKey = NULL;
        SecCertificateRef certRefs[1] = { expectedCertificate };
        CFArrayRef certArray = CFArrayCreate(kCFAllocatorDefault, (void *) certRefs, 1, NULL);
        SecPolicyRef policy = SecPolicyCreateBasicX509();
        SecTrustRef expTrust = NULL;
        OSStatus status = SecTrustCreateWithCertificates(certArray, policy, &expTrust);
        if (status == errSecSuccess) {
            expectedKey = SecTrustCopyPublicKey(expTrust);
        }
        CFRelease(expTrust);
        CFRelease(policy);
        CFRelease(certArray);
        
        // check a match
        if (actualKey != NULL && expectedKey != NULL && [(__bridge id) actualKey isEqual:(__bridge id)expectedKey]) {
            // public keys match, continue with other checks
            isMatch = true;
            
            if(actualKey) {
                CFRelease(actualKey);
            }
            if(expectedKey) {
                CFRelease(expectedKey);
            }
        }
        
        if (isMatch) {
            [challenge.sender performDefaultHandlingForAuthenticationChallenge:challenge];
            return;
        }
    }
    
    // public keys do not match
    [challenge.sender cancelAuthenticationChallenge:challenge];
}

@end
