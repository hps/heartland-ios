#import "HpsCardHolderData.h"

@implementation HpsCardHolderData
- (NSObject*) init {
    self = [super init];

    self.firstName = @"";
    self.lastName = @"";
    self.address = @"";
    self.city = @"";
    self.state = @"";
    self.zip = @"";
    
    return self;
}

- (NSString*) toXML
{    
    NSString *requestXMLhead = @"<hps:CardHolderData>";
    NSString *requestXMLTail = @"</hps:CardHolderData>";
    
    NSString *firstName = [NSString stringWithFormat:@"<hps:CardHolderFirstName>%@</hps:CardHolderFirstName>", self.firstName];
    NSString *lastName = [NSString stringWithFormat:@"<hps:CardHolderLastName>%@</hps:CardHolderLastName>", self.lastName];
    NSString *address = [NSString stringWithFormat:@"<hps:CardHolderAddr>%@</hps:CardHolderAddr>", self.address];
    NSString *city = [NSString stringWithFormat:@"<hps:CardHolderCity>%@</hps:CardHolderCity>", self.city];
    NSString *state = [NSString stringWithFormat:@"<hps:CardHolderState>%@</hps:CardHolderState>", self.state];
    NSString *zip = [NSString stringWithFormat:@"<hps:CardHolderZip>%@</hps:CardHolderZip>", self.zip];
    
    NSString *xml = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", requestXMLhead, firstName, lastName, address, city, state, zip, requestXMLTail];
    return xml;
}

@end
