#import "HpsHeader.h"

@implementation HpsHeader

- (NSObject*) init {
    self = [super init];
    
    self.versionNumber = @"";
    self.secretAPIKey = @"";
    self.developerID = @"";
    self.siteTrace = @"";
    
    return self;
}

- (NSString*) toXML
{
 
    NSString *requestXMLhead = @"<hps:Header>";
    NSString *requestXMLTail = @"</hps:Header>";
    
    NSString *versionNbr = [NSString stringWithFormat:@"<hps:VersionNbr>%@</hps:VersionNbr>", self.versionNumber];
    NSString *secretAPIKey = [NSString stringWithFormat:@"<hps:SecretAPIKey>%@</hps:SecretAPIKey>", self.secretAPIKey];
    NSString *developerID = [NSString stringWithFormat:@"<hps:DeveloperID>%@</hps:DeveloperID>", self.developerID];
    NSString *siteTrace = [NSString stringWithFormat:@"<hps:SiteTrace>%@</hps:SiteTrace>", self.siteTrace];
    
    NSString *xml = [NSString stringWithFormat:@"%@%@%@%@%@%@",requestXMLhead, versionNbr,secretAPIKey,developerID,siteTrace, requestXMLTail];
    return xml;
}

@end
