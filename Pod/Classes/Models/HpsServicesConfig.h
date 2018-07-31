#import <Foundation/Foundation.h>

@interface HpsServicesConfig : NSObject

@property (strong, nonatomic) NSString *licenseId;
@property (strong, nonatomic) NSString *siteId;
@property (strong, nonatomic) NSString *deviceId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *developerId;
@property (strong, nonatomic) NSString *versionNumber;
@property (strong, nonatomic) NSString *secretApiKey;
@property (strong, nonatomic) NSString *siteTrace;
@property (strong, nonatomic) NSString *serviceUri;
@property (nonatomic) BOOL isForTesting;

- (id) initWithSecretApiKey:(NSString *) secretApiKey;

- (id) initWithSecretApiKey:(NSString *) secretApiKey
                developerId:(NSString *) developerId
              versionNumber:(NSString *) versionNumber;

@end
