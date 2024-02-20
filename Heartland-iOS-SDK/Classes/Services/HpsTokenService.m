#import "HpsTokenService.h"
#import "HpsTokenData.h"

@interface HpsTokenService()

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSString *publicKey;
@property (nonatomic, strong) NSString *serviceURL;

@end

@implementation HpsTokenService

- (id) initWithPublicKey:(NSString *)publicKey
{
    if((self = [super init]))
    {
        self.publicKey = publicKey == nil ? @"" : [publicKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.queue = [[NSOperationQueue alloc] init];
        
        if(!publicKey)
        {
            [NSException raise:NSInvalidArgumentException format:@"publicKey can not be nil"];
        }
        
        NSArray *components = [self.publicKey componentsSeparatedByString:@"_"];
        NSString *env = [components[1] lowercaseString];
        
        if([env isEqual:@"prod"]) {
            self.serviceURL = @"https://api2-c.heartlandportico.com/SecureSubmit.v1/api/token";
        }
        else if ([env isEqualToString:@"cert"]) {
            self.serviceURL = @"https://cert.api2-c.heartlandportico.com/Hps.Exchange.PosGateway.Hpf.v1/api/token";
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
    NSDictionary *card = @{@"number": [self dataOrDefault:cardNumber withDefault:@""],
                           @"cvc": [self dataOrDefault:cvc withDefault:@""],
                           @"exp_month": [self dataOrDefault:expMonth withDefault:@""],
                           @"exp_year": [self dataOrDefault:expYear withDefault:@""],
                           };
    
    [self getTokenWithCardDictionary:card
           orEncryptedCardDictionary:nil
                    andResponseBlock:responseBlock];
}

- (void) getTokenWithCardTrackData:(NSString*)trackData
                  andResponseBlock:(void(^)(HpsTokenData*))responseBlock
{
    NSDictionary *card = @{@"track_method": @"swipe",
                           @"track": [self dataOrDefault:trackData withDefault:@""],
                           };
    
    [self getTokenWithCardDictionary:card
           orEncryptedCardDictionary:nil
                    andResponseBlock:responseBlock];
}

- (void) getTokenWithEncryptedCardTrackData:(NSString*)trackData
                                trackNumber:(NSString*)trackNumber
                                        ktb:(NSString*)ktb
                                   pinBlock:(NSString*)pinBlock
                           andResponseBlock:(void(^)(HpsTokenData*))responseBlock
{
    NSDictionary *card = @{@"track_method": @"swipe",
                           @"track": [self dataOrDefault:trackData withDefault:@""],
                           @"track_number": [self dataOrDefault:trackNumber withDefault:@""],
                           @"ktb": [self dataOrDefault:ktb withDefault:@""],
                           @"pin_block": [self dataOrDefault:pinBlock withDefault:@""],
                           };
    
    [self getTokenWithCardDictionary:nil
           orEncryptedCardDictionary:card
                    andResponseBlock:responseBlock];
}

- (void) getTokenWithCardDictionary:(NSDictionary *)card
          orEncryptedCardDictionary:(NSDictionary*)encryptedCard
                   andResponseBlock:(void(^)(HpsTokenData*))responseBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.serviceURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60];
    
    NSData *apiKey = [[NSString stringWithFormat:@"%@:", self.publicKey] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *authorization = [NSString stringWithFormat:@"Basic %@", [apiKey base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    
    NSMutableDictionary *tokenRequestData = [@{@"object": @"token",
                                               @"token_type": @"supt",
                                               } mutableCopy];
    
    if (card) {
        tokenRequestData[@"card"] = card;
    } else {
        tokenRequestData[@"encryptedcard"] = encryptedCard;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tokenRequestData
                                                       options:0
                                                         error:nil];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:authorization forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[@([jsonData length]) stringValue] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonData];    
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                    completionHandler:^(NSData *data, NSURLResponse *urlResponse, NSError *error) {
                               if (error != nil){
                                   
                                   HpsTokenData *response = [[HpsTokenData alloc] init];
                                   response.code = [@(error.code) stringValue];
                                   response.message = [error localizedDescription];
                                   response.type = @"error";
                              
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       responseBlock(response);
                                   });
                                   
                               }

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
                                           responseBlock(response);
                                       });
                                       
                                   }else{
                                       
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
                                       responseBlock(response);
                                       
                                   });

                               }else{
                                   
                                   HpsTokenData *response = [[HpsTokenData alloc] init];
                                   response.code = @"01";
                                   response.message = @"No data returned";
                                   response.type = @"error";
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       responseBlock(response);
                                   });
                               }
                               
                           }];
    [task resume];
}

- (NSString*) dataOrDefault:(NSString*)data
                withDefault:(NSString*)defaultData
{
    if (data) {
        return data;
    }
    
    return defaultData;
}

@end
