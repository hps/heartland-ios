//
//  HpsServicesConfig.h
//  SecureSubmit
//
//  Created by Roberts, Jerry on 7/10/14.
//  Copyright (c) 2014 Heartland Payment Systems. All rights reserved.
//

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

- (id) initWithSecretApiKey:(NSString *) secretApiKey;

- (id) initWithSecretApiKey:(NSString *) secretApiKey
                developerId:(NSString *) developerId
              versionNumber:(NSString *) versionNumber;

@end
