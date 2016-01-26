//
//  TokenService.h
//  Heartland-Tokenization
//
//  Created by Roberts, Jerry on 2/2/15.
//  Copyright (c) 2015 Heartland Payment Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HpsTokenData.h"

@interface HpsTokenService : NSObject

- (id) initWithPublicKey:(NSString*)publicKey;

- (void) getTokenWithCardNumber:(NSString*)cardNumber
                            cvc:(NSString*)cvc
                       expMonth:(NSString*)expMonth
                        expYear:(NSString*)expYear
               andResponseBlock:(void(^)(HpsTokenData*))responseBlock;
@end
