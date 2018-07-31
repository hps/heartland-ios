#import <Foundation/Foundation.h>
#import "HpsHeartSipResponse.h"

@interface HpsHeartSipParser : NSObject

+ (id <SipResposeInterface>)parseResponse:(NSData *)xml;
+ (id <SipResposeInterface>)parseResponseWithXmlString:(NSString *)xmlString;

@end
