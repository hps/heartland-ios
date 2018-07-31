#import "HpsHeartSipParser.h"
#import "HpsHeartSipResponse.h"
#import "NSObject+ObjectMap.h"

@implementation HpsHeartSipParser

+ (id <SipResposeInterface>)parseResponse:(NSData *)xml
{
	NSString *xmlString = [[NSString alloc]initWithData:xml encoding:NSUTF8StringEncoding];
	return [[HpsHeartSipResponse alloc]initWithXMLData:xmlString.XMLData];
}

+ (id <SipResposeInterface>)parseResponseWithXmlString:(NSString *)xmlString
{
		//NSLog(@"Response xml = %@",xmlString.XMLString);
	NSLog(@"Setting Field Data");
	NSData *data = xmlString.XMLData;
	HpsHeartSipResponse *response = [[HpsHeartSipResponse alloc]initWithXMLData:data  withSetRecord:YES ];
		//	HpsHeartSipResponse *response	= [[HpsHeartSipResponse alloc]initWithXMLData:xmlString.XMLData];
	return response;
}

@end
