#import "HpsServicesConfig.h"

@implementation HpsServicesConfig

- (id) init
{
    if( self = [super init])
    {
        self.licenseId = @"";
        self.siteId = @"";
        self.deviceId = @"";
        self.userName = @"";
        self.password = @"";
        self.developerId = @"";
        self.versionNumber = @"";
        self.secretApiKey = @"";
        self.siteTrace = @"";
        self.serviceUri = @"";
    }
    return self;
}

- (id) initWithSecretApiKey:(NSString *)secretApiKey
{
    if(self = [super init])
    {
        self.licenseId = @"";
        self.siteId = @"";
        self.deviceId = @"";
        self.userName = @"";
        self.password = @"";
        self.developerId = @"";
        self.versionNumber = @"";
        self.secretApiKey = secretApiKey;
        self.siteTrace = @"";
        self.serviceUri = @"";
    }
    return self;
}

- (id) initWithSecretApiKey:(NSString *)secretApiKey
                developerId:(NSString *)developerId
              versionNumber:(NSString *)versionNumber
{
    if(self = [super init])
    {
        self.licenseId = @"";
        self.siteId = @"";
        self.deviceId = @"";
        self.userName = @"";
        self.password = @"";
        self.secretApiKey = secretApiKey == nil ? @"" : [secretApiKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.developerId = developerId;
        self.versionNumber = versionNumber;
        self.siteTrace = @"";
        self.serviceUri = @"";
    }
    return self;
}

@end
