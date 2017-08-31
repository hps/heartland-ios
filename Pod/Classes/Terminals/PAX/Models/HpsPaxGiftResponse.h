//  Copyright (c) 2016 Heartland Payment Systems. All rights reserved.

#import <Foundation/Foundation.h>
#import "HpsBinaryDataScanner.h"
#import "HpsTerminalEnums.h"
#import "HpsPaxDeviceResponse.h"

@interface HpsPaxGiftResponse : HpsPaxDeviceResponse

@property (nonatomic,strong) NSString *authorizationCode;

- (id) initWithBuffer:(NSData*)buffer;
- (HpsBinaryDataScanner*) parseResponse;
- (void) mapResponse;

@end
