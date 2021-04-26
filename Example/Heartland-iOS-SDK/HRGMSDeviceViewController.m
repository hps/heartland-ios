//
//  HRGMSDeviceViewController.m
//  Heartland-iOS-SDK_Example
//
//  Created by Desimini, Wilson on 4/26/21.
//  Copyright © 2021 Shaunti Fondrisi. All rights reserved.
//

#import "HRGMSDeviceViewController.h"
#import "HRGMSDeviceManager.h"

@interface HRGMSDeviceViewController ()

@property (strong, nonatomic, readonly) HpsConnectionConfig *config;
@property (weak, nonatomic) UIButton *scanButton;

@end

@implementation HRGMSDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureGMSDeviceManager];
    [self addScanControls];
}

- (void)viewDidAppear:(BOOL)animated {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didReceiveScanStateNotification:)
                                               name:AppNotificationGMSDeviceScanStateDidUpdate
                                             object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (HpsConnectionConfig *)config {
    HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
    config.versionNumber = @"3409";
    config.developerID = @"002914";
    config.username = @"701389328";
    config.password = @"$Test1234";
    config.siteID = @"142914";
    config.deviceID = @"6399854";
    config.licenseID = @"142827";
    return config;
}

- (void)configureGMSDeviceManager {
    [HRGMSDeviceManager.sharedInstance addDeviceWithConfig:self.config];
}

- (void)addScanControls {
    UIButton *scanButton = UIButton.new;
    scanButton.translatesAutoresizingMaskIntoConstraints = NO;
    scanButton.backgroundColor = UIColor.systemGreenColor;
    [scanButton addTarget:self action:@selector(scanTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [scanButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:100],
        [scanButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [scanButton.heightAnchor constraintEqualToConstant:52],
        [scanButton.widthAnchor constraintEqualToConstant:180]
    ]];
    
    _scanButton = scanButton;
    
    [self updateScanControlsForScanning:NO];
}

- (void)didReceiveScanStateNotification:(NSNotification *)notification {
    [self updateScanControlsForScanning:[notification.object boolValue]];
}

- (void)updateScanControlsForScanning:(BOOL)isScanning {
    [_scanButton setTitle:isScanning ? @"Stop Scan" : @"Scan" forState:UIControlStateNormal];
}

- (void)scanTapped {
    if (HRGMSDeviceManager.sharedInstance.deviceIsScanning) {
        [HRGMSDeviceManager.sharedInstance stopScan];
    } else {
        [HRGMSDeviceManager.sharedInstance startScan];
    }
}

@end
