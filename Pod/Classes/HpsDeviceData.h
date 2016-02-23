//
//  HpsDeviceData.h
//  Pods
//
//  Created by Shaunti Fondrisi on 2/11/16.
//
//

#import <Foundation/Foundation.h>

@interface HpsDeviceData : NSObject
@property (nonatomic) NSString* merchantId;
@property (nonatomic) NSString* deviceId;
@property (nonatomic) NSString* email;
@property (nonatomic) NSString* applicationId;
@property (nonatomic) NSString* hardwareTypeName;
@property (nonatomic) NSString* softwareVersion;
@property (nonatomic) NSString* configurationName;
@property (nonatomic) NSString* peripheralName;
@property (nonatomic) NSString* peripheralSoftware;
@property (nonatomic) NSString* activationCode;
@property (nonatomic) NSString* apiKey;

@end
