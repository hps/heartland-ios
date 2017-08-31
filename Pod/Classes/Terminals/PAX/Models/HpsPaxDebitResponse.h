//  Copyright (c) 2016 Heartland Payment Systems. All rights reserved.

#import <Foundation/Foundation.h>
#import "HpsPaxDeviceResponse.h"
#import "HpsTokenData.h"

@interface HpsPaxDebitResponse : HpsPaxDeviceResponse

@property (nonatomic,strong) NSString *authorizationCode;


- (id) initWithBuffer:(NSData*)buffer;
- (HpsBinaryDataScanner*) parseResponse;
- (void) mapResponse;

@end
