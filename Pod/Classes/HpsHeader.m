//
//  HpsHeader.m
//  Copyright (c) 2015 Heartland Payment Systems. All rights reserved.
//
//  Created by Shaunti Fondrisi on 12/8/15.
//
//

#import "HpsHeader.h"

@implementation HpsHeader

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
