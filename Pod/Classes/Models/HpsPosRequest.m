#import "HpsPosRequest.h"

@implementation HpsPosRequest
- (NSObject*) init {
    self = [super init];
    
    return self;
}
- (NSObject*) initWithHeader: (HpsHeader*)header andTransaction:(HpsTransaction*)transaction {
    self = [super init];
    
    self.header = header;
    self.transaction = transaction;
    
    return self;
}

- (NSString*) toXML
{
    NSString *requestXMLhead = @"<?xml version=\"1.0\" ?><SOAP:Envelope xmlns:SOAP=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:hps=\"http://Hps.Exchange.PosGateway\"><SOAP:Body><hps:PosRequest><hps:Ver1.0>";
    NSString *requestXMLTail = @"</hps:Ver1.0></hps:PosRequest></SOAP:Body></SOAP:Envelope>";
 
    NSString *xml = [NSString stringWithFormat:@"%@%@%@%@",requestXMLhead, [self.header toXML],[self.transaction toXML], requestXMLTail];
    
    return xml;
}

@end
