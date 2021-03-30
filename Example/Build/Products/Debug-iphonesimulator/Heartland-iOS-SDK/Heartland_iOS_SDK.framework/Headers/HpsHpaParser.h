#import <Foundation/Foundation.h>
#import "HpsHpaResponse.h"

@interface HpsHpaParser : NSObject

+ (id <HpaResposeInterface>)parseResponse:(NSData *)xml;
+ (id <HpaResposeInterface>)parseResponseWithXmlString:(NSString *)xmlString;

@end
