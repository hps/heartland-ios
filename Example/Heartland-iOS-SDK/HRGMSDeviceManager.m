//
//  HRGMSDeviceManager.m
//  Heartland-iOS-SDK_Example
//
//  Created by Desimini, Wilson on 4/26/21.
//  Copyright © 2021 Shaunti Fondrisi. All rights reserved.
//

#import "HRGMSDeviceManager.h"
#import "HRGMSTransactionService.h"

@interface HRGMSDeviceManager ()
<
GMSDeviceDelegate,
GMSDeviceScanObserver
>

@property (strong, nonatomic, nullable) GMSDevice *device;
@property (strong, nonatomic) HRGMSTransactionService *transactionService;

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
    device.deviceScanObserver = self;
    _transactionService = [[HRGMSTransactionService alloc] initWithDevice:device];
    _device = device;
}

- (void)startScan {
    [_device scan];
}

- (void)stopScan {
    [_device stopScan];
}

- (void)connectToTerminal:(HpsTerminalInfo *)terminal {
    [_device connectDevice:terminal];
}

- (void)disconnect {
    [_device.gmsWrapper disconnect];
}

- (void)doTransactionWithModel:(GMSBuilderModel *)model {
    [_transactionService doTransactionWithModel:model];
}

// MARK: GMSDeviceDelegate

- (void)onBluetoothDeviceList:(NSMutableArray * _Nonnull)peripherals {
    [NSNotificationCenter.defaultCenter postNotificationName:AppNotificationGMSDeviceFound object:peripherals];
}

- (void)onConnected {
    [NSNotificationCenter.defaultCenter postNotificationName:AppNotificationGMSDeviceConnectionDidUpdate
                                                      object:[NSNumber numberWithBool:YES]];
}

- (void)onDisconnected {
    [NSNotificationCenter.defaultCenter postNotificationName:AppNotificationGMSDeviceConnectionDidUpdate
                                                      object:[NSNumber numberWithBool:NO]];
}

- (void)onError:(NSError * _Nonnull)deviceError {
    [NSNotificationCenter.defaultCenter postNotificationName:AppNotificationGMSDeviceError
                                                      object:deviceError];
}

// MARK: GMSDeviceScanObserver

- (void)deviceDidUpdateScanStateTo:(BOOL)isScanning {
    [NSNotificationCenter.defaultCenter postNotificationName:AppNotificationGMSDeviceScanStateDidUpdate
                                                      object:[NSNumber numberWithBool:_device.isScanning]];
}

@end
