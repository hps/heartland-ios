//
//  HpsHeader.h
//  Copyright (c) 2015 Heartland Payment Systems. All rights reserved.
//
//  Created by Shaunti Fondrisi on 12/8/15.
//
//

#import <Foundation/Foundation.h>

@interface HpsHeader : NSObject

@property (nonatomic, strong) NSString *versionNumber;
@property (nonatomic, strong) NSString *secretAPIKey;
@property (nonatomic, strong) NSString *developerID;
@property (nonatomic, strong) NSString *siteTrace;

@property (nonatomic, strong) NSString *licenseId;
@property (nonatomic, strong) NSString *siteId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *deviceId;

- (NSString*) toXML;

@end
