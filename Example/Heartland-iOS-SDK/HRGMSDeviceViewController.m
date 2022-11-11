//
//  HRGMSDeviceViewController.m
//  Heartland-iOS-SDK_Example
//
//  Created by Desimini, Wilson on 4/26/21.
//  Copyright © 2021 Shaunti Fondrisi. All rights reserved.
//

#import "HRGMSDeviceViewController.h"
#import "HRGMSDeviceManager.h"
#import <Heartland_iOS_SDK/Heartland_iOS_SDK-Swift.h>
#import "HRGMSTransactionViewController.h"

@interface HRGMSDeviceViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray<HpsTerminalInfo *> *terminals;
@property (strong, nonatomic, nullable) HpsTerminalInfo *selectedTerminal;
@property (nonatomic) BOOL terminalIsConnected;
@property (weak, nonatomic) UIButton *scanButton;
@property (weak, nonatomic) UIButton *transactionButton;
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) HRGMSTransactionViewController *transactionController;

@end

@implementation HRGMSDeviceViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _terminals = @[];
        _terminalIsConnected = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureGMSDeviceManager];
    [self addScanControls];
    [self configureTransactionButton];
    [self addTerminalsTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didReceiveScanStateNotification:)
                                               name:AppNotificationGMSDeviceScanStateDidUpdate
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didReceiveDeviceFoundNotification:)
                                               name:AppNotificationGMSDeviceFound
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didReceiveDeviceConnectionNotification:)
                                               name:AppNotificationGMSDeviceConnectionDidUpdate
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didReceiveDeviceErrorNotification:)
                                               name:AppNotificationGMSDeviceError
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
    config.timeout = 60;
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

- (void)configureTransactionButton {
    UIButton *transactionButton = UIButton.new;
    [transactionButton addTarget:self
                          action:@selector(transactionTapped)
                forControlEvents:UIControlEventTouchUpInside];
    transactionButton.backgroundColor = UIColor.systemRedColor;
    [transactionButton setTitle:@"Do Transaction" forState:UIControlStateNormal];
    transactionButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:transactionButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [transactionButton.topAnchor constraintEqualToAnchor:_scanButton.bottomAnchor constant:11],
        [transactionButton.centerXAnchor constraintEqualToAnchor:_scanButton.centerXAnchor],
        [transactionButton.heightAnchor constraintEqualToConstant:52],
        [transactionButton.widthAnchor constraintEqualToConstant:180]
    ]];
    
    _transactionButton = transactionButton;
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

- (void)setTerminals:(NSArray<HpsTerminalInfo *> *)terminals {
    _terminals = terminals;
    [_tableView reloadData];
}

- (void)setTerminalIsConnected:(BOOL)terminalIsConnected {
    _terminalIsConnected = terminalIsConnected;
    
    if (_selectedTerminal) {
        NSIndexPath *path;
        
        for (int i = 0; i < _terminals.count; i++) {
            HpsTerminalInfo *terminal = _terminals[i];
            
            if ([terminal.identifier isEqual:_selectedTerminal.identifier]) {
                path = [NSIndexPath indexPathForRow:i inSection:0];
                break;
            }
        }
        
        if (!_terminalIsConnected) {
            [self setSelectedTerminal:nil];
        }
        
        if (path) {
            [_tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } else {
        [_tableView reloadData];
    }
}

- (void)didReceiveDeviceFoundNotification:(NSNotification *)notification {
    [self setTerminals:notification.object];
}

- (void)didReceiveDeviceErrorNotification:(NSNotification *)notification {
    NSError *error = notification.object;
    [self presentAlertWithMessage:error.localizedDescription];
}

- (void)didReceiveDeviceConnectionNotification:(NSNotification *)notification {
    [self setTerminalIsConnected:[notification.object boolValue]];
}

- (void)addTerminalsTableView {
    UITableView *tableView = UITableView.new;
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [tableView registerClass:UITableViewCell.self forCellReuseIdentifier:@"cellId"];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    
    [NSLayoutConstraint activateConstraints:@[
        [tableView.topAnchor constraintEqualToAnchor:_transactionButton.bottomAnchor constant:16],
        [tableView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [tableView.widthAnchor constraintEqualToConstant:400],
        [tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-16]
    ]];
    
    _tableView = tableView;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    HpsTerminalInfo *terminal = _terminals[indexPath.row];
    
    cell.textLabel.text = terminal.name;
    
    if ([_selectedTerminal.identifier isEqual:terminal.identifier]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        if (_terminalIsConnected) {
            [cell.textLabel setTextColor:UIColor.blueColor];
        } else {
            [cell.textLabel setTextColor:UIColor.blackColor];
        }
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _terminals.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HpsTerminalInfo *terminal = _terminals[indexPath.row];
    
    if (_selectedTerminal) {
        if ([terminal.identifier isEqual:_selectedTerminal.identifier]) {
            terminal = nil;
        } else if (_terminalIsConnected) {
            [self presentAlertWithMessage:@"must disconnect from terminal before connecting to another"];
            return;
        }
    }
    
    [self setSelectedTerminal:terminal];
}

- (void)setSelectedTerminal:(HpsTerminalInfo *)selectedTerminal {
    _selectedTerminal = selectedTerminal;
    
    if (_selectedTerminal) {
        [HRGMSDeviceManager.sharedInstance connectToTerminal:_selectedTerminal];
    } else {
        [HRGMSDeviceManager.sharedInstance disconnect];
    }
}

- (void)transactionTapped {
    [self presentTransactionController];
}

- (void)presentAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)presentTransactionController {
    HRGMSTransactionViewController *controller = HRGMSTransactionViewController.new;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:YES completion:nil];
}

@end
