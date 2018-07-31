#import <Foundation/Foundation.h>
#import "HpsConfiguredServices.h"
#import "HpsTableServiceConnector.h"
#import "HpsTableServiceConfiguration.h"

@interface HpsServiceContainer : NSObject

@property NSMutableDictionary *configurations;

+ (id)sharedInstance;
+ (void)configureService :(HpsConfiguration *)config;
-(HpsConfiguredServices*) GetConfiguration:(NSString *)configName;
-(void)addConfiguration:(NSString *)configName withConfigServices:(HpsConfiguredServices*) config;
-(HpsTableServiceConnector *) GetTableServiceClient:(NSString *) configName;

@end
