	//  Copyright (c) 2017 Heartland Payment Systems. All rights reserved.

#import <Foundation/Foundation.h>
#import "HpsHeartSipResponse.h"

@interface HpsHeartSipParser : NSObject

+ (id <SipResposeInterface>)parseResponse:(NSData *)xml;
+ (id <SipResposeInterface>)parseResponseWithXmlString:(NSString *)xmlString;

@end
