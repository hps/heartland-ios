#ifndef GPServicesConfig_h
#define GPServicesConfig_h

#import <Foundation/Foundation.h>

@interface GPServicesConfig : NSObject

@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) NSString* siteId;
@property (nonatomic, strong) NSString* deviceId;
@property (nonatomic, strong) NSString* licenseId;
@property (nonatomic, strong) NSString* developerId;
@property (nonatomic, strong) NSString* versionNumber;
@property (nonatomic, strong) NSString* uniqueDeviceId;
@property (nonatomic, strong) NSString* secretApiKey;
@property (nonatomic, strong) NSString* siteTrace;
@property (nonatomic, strong) NSString* serviceUrl;
@property (nonatomic) int timeout;

@end

#endif /* GPServicesConfig_h */
