#import <Foundation/Foundation.h>
#import "HpsTokenData.h"

@interface HpsGatewayData : NSObject

@property (nonatomic, strong) NSString *avsResultCode;
@property (nonatomic, strong) NSString *avsResultText;
@property (nonatomic, strong) NSString *authorizationCode;

@property (nonatomic, strong) NSString *cardType;
@property (nonatomic, strong) NSString *responseCode;
@property (nonatomic, strong) NSString *responseText;
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, readwrite) int referenceNumber;

@property (nonatomic, strong) NSString *gatewayResponseCode;
@property (nonatomic, strong) NSString *gatewayResponseText;
@property (nonatomic, strong) NSString *gatewayTxnId;

@property (nonatomic, strong) HpsTokenData *tokenResponse;

@end
