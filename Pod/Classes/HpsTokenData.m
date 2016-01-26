//
//  TokenResponse.m
//  Heartland-Tokenization
//
//  Created by Roberts, Jerry on 2/2/15.
//  Copyright (c) 2015 Heartland Payment Systems. All rights reserved.
//

#import "HpsTokenData.h"

@implementation HpsTokenData

- (NSString*) toXML
{
    NSString *tokenValue = [NSString stringWithFormat:@"<hps:TokenValue>%@</hps:TokenValue>", self.tokenValue];
    return [NSString stringWithFormat:@"%@%@%@",@"<hps:TokenData>", tokenValue, @"</hps:TokenData>"];
}

@end
