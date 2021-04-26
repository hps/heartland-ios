//
//  HRGMSDeviceManager.m
//  Heartland-iOS-SDK_Example
//
//  Created by Desimini, Wilson on 4/26/21.
//  Copyright © 2021 Shaunti Fondrisi. All rights reserved.
//

#import "HRGMSDeviceManager.h"
#import <Heartland_iOS_SDK/Heartland_iOS_SDK-Swift.h>
#import "HRGMS+Notifications.h"

@interface HRGMSDeviceManager ()<GMSDeviceDelegate>

@property (strong, nonatomic, nullable) GMSDevice *device;

@end

@implementation HRGMSDeviceManager

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id _sharedInstance = nil;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (BOOL)deviceIsScanning {
    return _device.isScanning;
}

- (void)addDeviceWithConfig:(HpsConnectionConfig *)config {
    HpsWiseCubeDevice *device = [[HpsWiseCubeDevice alloc] initWithConfig:config];
    device.deviceDelegate = self;
    _device = device;
}

- (void)startScan {
    [_device scan];
}

- (void)stopScan {
    [_device stopScan];
}

- (void)onBluetoothDeviceList:(NSMutableArray * _Nonnull)peripherals {
    //
}

- (void)onConnected {
    //
}

- (void)onDisconnected {
    //
}

- (void)onError:(NSError * _Nonnull)deviceError {
    //
}

@end
