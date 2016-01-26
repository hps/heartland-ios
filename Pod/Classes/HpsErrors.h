//
//  HpsErrors.h
//  Copyright (c) 2015 Heartland Payment Systems. All rights reserved.
//
//  Created by Shaunti Fondrisi on 12/22/15.
//
//

#import <Foundation/Foundation.h>


NSString *HpsErrorDomain = @"com.heartlandpaymentsystems.iossdk";

enum {
    GatewayError,
    IssuerError,
    TokenError,
    ConfigurationError,
    CocoaError
};