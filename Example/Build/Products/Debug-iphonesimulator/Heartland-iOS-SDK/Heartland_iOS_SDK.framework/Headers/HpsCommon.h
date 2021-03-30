#import <Foundation/Foundation.h>

enum  {
    GatewayError,
    IssuerError,
    TokenError,
    ConfigurationError,
    CocoaError
};

@interface HpsCommon : NSObject

@property(nonatomic,retain)NSString *hpsErrorDomain;

+(HpsCommon*)sharedInstance;

@end
