//
//  HpsConnectDeviceViewController.m
//  Heartland-iOS-SDK_Example
//
//  Created by Chibwe, Martin on 4/25/22.
//  Copyright © 2022 Shaunti Fondrisi. All rights reserved.
//

#import "HpsConnectDeviceViewController.h"
#import <Heartland_iOS_SDK/Heartland_iOS_SDK-Swift.h>
#import <Heartland_iOS_SDK/Heartland-iOS-SDK-umbrella.h>
#import <Heartland_iOS_SDK/Heartland_iOS_SDK-Swift.h>
#import "Heartland_iOS_SDK-Swift.h"
#import "HpsHpaDevice.h"

@interface HpsConnectDeviceViewController ()<HpsC2xDeviceDelegate,GMSTransactionDelegate,GMSClientAppDelegate, UITextFieldDelegate>

@property HpsC2xDevice *device;
@property HpsTerminalInfo *deviceList;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *tipAdjustment;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceTerminaltype;
@property (weak, nonatomic) IBOutlet UILabel *deviceIdentififerLabel;
@property (weak, nonatomic) IBOutlet UILabel *clientTransactionIdLabel;

@property HpsTerminalResponse *response;

@property (nonatomic, strong) NSMutableArray *devicesFound;
@end

@implementation HpsConnectDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.device.deviceDelegate = self;
    self.device.transactionDelegate = self;
    self.amountTextField.delegate = self;
    self.tipAdjustment.delegate = self;


}

-(void)checkHpaInit {
    self.device = [self setupDevice];
    [self.device initialize];
    self.device.deviceDelegate = self;

}
- (HpsC2xDevice*) setupDevice
{
    HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
//    config.ipAddress = @"10.12.220.130";
//    config.port = @"12345";
//    config.connectionMode = HpsConnectionModes_TCP_IP;
    config.username = @"703674685";
    config.password = @"$Test1234";
    config.siteID = @"372880";
    config.deviceID = @"90915912";
    config.licenseID = @"372711";
    config.developerID = @"002914";
    config.versionNumber = @"3409";
    NSInteger timeout = 120;
    config.timeout = &(timeout);
    HpsC2xDevice * device = [[HpsC2xDevice alloc] initWithConfig:config];
    
    return device;
}

- (IBAction)scanButtonTapped:(id)sender {
    [self checkHpaInit];
}
- (IBAction)rescanButtonTapped:(id)sender {

}
-(IBAction)creditSaleButton:(id)sender {
    self.device.transactionDelegate = self;
    Float32 amount = [self.amountTextField.text floatValue];
    HpsC2xCreditSaleBuilder *builder = [[HpsC2xCreditSaleBuilder alloc] initWithDevice:self.device];
    builder.amount = [[NSDecimalNumber alloc] initWithDouble: amount];
    [builder execute];
}

-(IBAction)voidSaleButton:(id)sender {
    HpsC2xCreditSaleBuilder *builder = [[HpsC2xCreditSaleBuilder alloc] initWithDevice:self.device];
    builder.transactionId = self.response.transactionId;
    [builder execute];
}
-(IBAction)enterCardManualEntry:(id)sender {
    HpsCreditCard *card = [[HpsCreditCard alloc] init];
    card.cardNumber = @"374245001751006";
    card.expMonth = 12;
    card.expYear = 2024;
    card.cvv = @"201";
    
    HpsC2xCreditAuthBuilder *builder = [[HpsC2xCreditAuthBuilder alloc] initWithDevice:self.device];
    Float32 amount = [self.amountTextField.text floatValue];
    builder.amount = [[NSDecimalNumber alloc] initWithDouble:amount];
    builder.creditCard = card;
    [builder execute];

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

#pragma mark - Navigation



- (void)onBluetoothDeviceList:(NSMutableArray * _Nonnull)peripherals {

    if (peripherals == nil || [peripherals count] == 0) {
        return;
    }
    self.devicesFound = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < peripherals.count; i++) {
        self.deviceList = [peripherals objectAtIndex:i];
        self.deviceNameLabel.text = self.deviceList.name;
        self.deviceTerminaltype.text = self.deviceList.terminalType;
        self.deviceIdentififerLabel.text = [self.deviceList.identifier UUIDString];
        [self.device stopScan];
        [self.device connectDevice: self.deviceList ];
    }
}

- (void)onConnected {

}

- (void)onDisconnected {

}

- (void)onError:(NSError * _Nonnull)deviceError {
}

- (void)onConfirmAmount:(NSDecimal)amount {
    
    [self.device confirmAmount:amount];
}

- (void)onConfirmApplication:(NSArray<AID *> * _Nonnull)applications {
    
    [self.device confirmApplication:[applications objectAtIndex:0]];

}

- (void)onTransactionCancelled {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"TransactionCancelled" message:@"Transaction Cancelled" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)deviceConnected {
    
}


- (void)deviceDisconnected {
    
}


- (void)deviceFound:(NSObject * _Nonnull)device {

}


- (void)onStatus:(enum HpsTransactionStatus)status {

}


- (void)onTransactionComplete:(NSString * _Nonnull)result response:(HpsTerminalResponse * _Nonnull)response {

}


- (void)requestAIDSelection:(NSArray<AID *> * _Nonnull)applications {
    
}


- (void)requestAmountConfirmation:(NSDecimal)amount {

}


- (void)requestPostalCode:(NSString * _Nonnull)maskedPan expiryDate:(NSString * _Nonnull)expiryDate cardholderName:(NSString * _Nonnull)cardholderName {
    
}


- (void)requestSaFApproval {
    
}


- (void)searchComplete {
    
}


- (void)onTransactionComplete:(HpsTerminalResponse * _Nonnull)response {

}

- (void)onStatusUpdate:(enum HpsTransactionStatus)transactionStatus {
    NSString *status = nil;
    
//    NSMutableArray *resultStatus = [[NSMutableArray alloc] init];
    switch (transactionStatus) {
        case 0:
            status = @"waiting For Configuration";
            break;
        case 1:
            status = @"Configuring Terminal";
            break;
        case 2:
            status = @"Configuration Failed Try Again";
            break;
        case 3:
            status = @"Ready";
            break;
        case 4:
            status = @"Started";
            break;
        case 5:
            status = @"Waiting ForCard";
            break;
        case 6:
            status = @"Insert Card";
            break;
        case 7:
            status = @"Remove Card";
            break;
        case 8:
            status = @"Status Card Removed";
            break;
        case 9:
            status = @"Please Wait";
            break;
        case 10:
            status = @"Please See Phone";
            break;
        case 11:
            status = @"Status Use Magstripe";
            break;
        case 12:
            status = @"Try Again";
            break;
        case 13:
            status = @"Swipe Error ReSwipe";
            break;
        case 14:
            status = @"no Emv Apps";
            break;
        case 15:
            status = @"Application Expired";
            break;
        case 16:
            status = @"Card Read Error";
            break;
        case 17:
            status = @"processing";
            break;
        case 18:
            status = @"processing Do Not RemoveCard";
            break;
        case 19:
            status = @"present Card";
            break;
        case 20:
            status = @"present Card Again";
            break;
        case 21:
            status = @"insert Swipe Or Try Another Card";
            break;
        case 22:
            status = @"insert Or Swipe Card";
            break;
        case 23:
            status = @"multiple Card Detected";
            break;
        case 24:
            status = @"contactless Card Still In Field";
            break;
        case 25:
            status = @"transaction Terminated";
            break;
        case 26:
            status = @"waiting For Terminal";
            break;
        case 27:
            status = @"card Detected";
            break;
        case 28:
            status = @"card Blocked";
            break;
        case 29:
            status = @"not Authorized";
            break;
        case 30:
            status = @"not Accepted RemoveCard";
            break;
        case 31:
            status = @"fallback To MSR";
            break;
        case 32:
            status = @"fallback To Chip";
            break;
        case 33:
            status = @"waiting For Amount Confirmation";
            break;
        case 34:
            status = @"waiting For Aid Selection";
            break;
        case 35:
            status = @"waiting For PostalCode";
            break;
        case 36:
            status = @"waiting For Saf Approval";
            break;
        case 37:
            status = @"card Holder Bypassed PIN";
            break;
        case 38:
            status = @"processing Saf";
            break;
        case 39:
            status = @"requesting Online Processing";
            break;
        case 40:
            status = @"reversal";
            break;
        case 41:
            status = @"reversal In Progress";
            break;
        case 42:
            status = @"complete";
            break;
        case 43:
            status = @"cancel";
            break;
        case 44:
            status = @"cancelling";
            break;
        case 45:
            status = @"cancelled";
            break;
        case 46:
            status = @"error";
            break;
        case 47:
            status = @"unknown";
            break;
        case 48:
            status = @"terminalDeclined";
            break;
        default:
            break;
    }

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Status" message: status preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];

}

@end
