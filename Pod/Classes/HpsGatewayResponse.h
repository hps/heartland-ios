//
//  HpsGatewayResponse.h
//  Pods
//
//  Created by Shaunti Fondrisi on 12/17/15.
//
//

#import <Foundation/Foundation.h>
#import "HpsTokenResponse.h"

@interface HpsGatewayResponse : NSObject

@property (nonatomic, strong) NSString *avsResultCode;
@property (nonatomic, strong) NSString *avsResultText;
@property (nonatomic, strong) NSString *authorizationCode;

@property (nonatomic, strong) NSString *cardType;
@property (nonatomic, strong) NSString *responseCode;
@property (nonatomic, strong) NSString *responseText;
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSString *referenceNumber;

@property (nonatomic, strong) HpsTokenResponse *tokenResponse;

@end
