//
//  TokenResponse.h
//  Heartland-Tokenization
//
//  Created by Roberts, Jerry on 2/2/15.
//  Copyright (c) 2015 Heartland Payment Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HpsTokenResponse : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *param;
@property (nonatomic, strong) NSString *tokenValue;
@property (nonatomic, strong) NSString *tokenExpire;
@property (nonatomic, strong) NSString *tokenType;
@property (nonatomic, strong) NSString *cardNumber;

@end
