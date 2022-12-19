#import "HpsCardData.h"

@implementation HpsCardData

- (NSObject*) init {
    self = [super init];    
    
    self.requestToken = NO;
    self.cardPresent = NO;
    self.readerPresent = NO;
    self.expMonth = @"";
    self.expYear = @"";
    self.cardNumber = @"";
    self.cvv2 = @"";
    
    return self;
}

- (NSString*) toXML
{
    NSString *requestXMLhead = @"<hps:CardData>";
    NSString *requestXMLTail = @"</hps:CardData>";
    NSString *xml;
    
    if (self.tokenResponse != nil) {
         xml = [NSString stringWithFormat:@"%@%@%@",requestXMLhead, [self.tokenResponse toXML], requestXMLTail];
        
    }else{
        
        //Manual entry
        
        NSString *requestToken = [NSString stringWithFormat:@"<hps:TokenRequest>%@</hps:TokenRequest>", self.requestToken ? @"Y" : @"N"];
        NSString *cardPresent = [NSString stringWithFormat:@"<hps:CardPresent>%@</hps:CardPresent>", self.cardPresent ? @"Y" : @"N"];
        NSString *readerPresent = [NSString stringWithFormat:@"<hps:ReaderPresent>%@</hps:ReaderPresent>", self.readerPresent ? @"Y" : @"N"];
        
        NSString *cardNumber = [NSString stringWithFormat:@"<hps:CardNbr>%@</hps:CardNbr>", self.cardNumber ];
        NSString *expMonth = [NSString stringWithFormat:@"<hps:ExpMonth>%@</hps:ExpMonth>", self.expMonth ];
        NSString *expYear = [NSString stringWithFormat:@"<hps:ExpYear>%@</hps:ExpYear>", self.expYear ];
        NSString *cvv = [self.cvv2 length] > 0 ?[NSString stringWithFormat:@"<hps:CVV2>%@</hps:CVV2>", self.cvv2 ] : @"";
        
        xml = [NSString stringWithFormat:@"%@<hps:ManualEntry>%@%@%@%@%@%@</hps:ManualEntry>%@%@",requestXMLhead, expMonth, cardPresent, expYear, readerPresent, cardNumber,cvv, requestToken, requestXMLTail];
    }
    
    return xml;
}

@end
