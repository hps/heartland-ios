#ifndef GPServicesContainer_h
#define GPServicesContainer_h

#import <Foundation/Foundation.h>
#import <GlobalPaymentsApi/GPGateway.h>
#import <GlobalPaymentsApi/GPServicesConfig.h>

@interface GPServicesContainer : NSObject {
    NSMutableDictionary* configurations;
}

+ (void) configure:(GPServicesConfig*) config;
+ (void) configure:(GPServicesConfig*) config withName:(NSString*) name;
+ (instancetype) instance;
- (GPGateway*) getClient:(NSString*) name;

@end

#endif /* GPServicesContainer_h */
