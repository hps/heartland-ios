#import <Foundation/Foundation.h>

@interface HpsConnectionConfig : NSObject

@property (nonatomic) NSInteger connectionMode;
@property (nonatomic, strong) NSString *ipAddress;
@property (nonatomic, strong) NSString *port;
@property (nonatomic) NSInteger baudeRate;
@property (nonatomic) NSInteger parity;
@property (nonatomic) NSInteger stopBits;
@property (nonatomic) NSInteger dataBits;
@property (nonatomic) NSInteger *timeout;

@property (nonatomic, strong) NSString *versionNumber;
@property (nonatomic, strong) NSString *developerID;
@property (nonatomic, strong) NSString *licenseID;
@property (nonatomic, strong) NSString *siteID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic) BOOL isProduction;

@end
