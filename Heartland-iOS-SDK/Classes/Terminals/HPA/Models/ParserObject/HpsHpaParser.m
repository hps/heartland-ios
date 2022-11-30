#import "HpsHpaParser.h"
#import "HpsHpaResponse.h"
#import "NSObject+ObjectMap.h"

@implementation HpsHpaParser

+ (id <HpaResposeInterface>)parseResponse:(NSData *)xml
{
	NSString *xmlString = [[NSString alloc]initWithData:xml encoding:NSUTF8StringEncoding];
	return [[HpsHpaResponse alloc]initWithXMLData:xmlString.XMLData];
}

+ (id <HpaResposeInterface>)parseResponseWithXmlString:(NSString *)xmlString
{
		//NSLog(@"Response xml = %@",xmlString.XMLString);
	NSLog(@"Setting Field Data");
	NSData *data = xmlString.XMLData;
	HpsHpaResponse *response = [[HpsHpaResponse alloc]initWithXMLData:data  withSetRecord:YES ];
		//	HpsHpaResponse *response	= [[HpsHpaResponse alloc]initWithXMLData:xmlString.XMLData];
	return response;
}

@end
