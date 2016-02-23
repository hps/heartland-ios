//
//  HpsDeviceData.m
//  Pods
//
//  Created by Shaunti Fondrisi on 2/11/16.
//
//

#import "HpsDeviceData.h"

@implementation HpsDeviceData
- (id)init {
    self = [super init];
    if (!self) return nil;
    
    
    self.merchantId = @"";
    self.deviceId = @"";
    self.email = @"";
    self.applicationId = @"";
    self.hardwareTypeName = @"";
    self.softwareVersion = @"";
    self.configurationName = @"";
    self.peripheralName = @"";
    self.peripheralSoftware = @"";
    self.activationCode = @"";
    self.apiKey = @"";
    return self;
}

@end
