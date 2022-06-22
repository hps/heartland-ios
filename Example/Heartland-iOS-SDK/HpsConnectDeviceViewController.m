//
//  HpsConnectDeviceViewController.m
//  Heartland-iOS-SDK_Example
//
//  Created by Chibwe, Martin on 4/25/22.
//  Copyright © 2022 Shaunti Fondrisi. All rights reserved.
//
//#import "SVProgressHUD.h"
#import "HpsConnectDeviceViewController.h"
#import <Heartland_iOS_SDK/Heartland_iOS_SDK-Swift.h>
#import <Heartland_iOS_SDK/Heartland-iOS-SDK-umbrella.h>
#import <Heartland_iOS_SDK/Heartland_iOS_SDK-Swift.h>
#import "Heartland_iOS_SDK-Swift.h"
#import "HpsHpaDevice.h"
//#import "HpsListDevicesViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
//#import "HpsDetailsViewController.h"
@interface HpsConnectDeviceViewController ()<HpsC2xDeviceDelegate,GMSTransactionDelegate,GMSClientAppDelegate, UITextFieldDelegate, CBPeripheralDelegate,CBCentralManagerDelegate>

//@property (nonatomic) Hps *detailVC;
@property HpsC2xDevice *device;
@property HpsTerminalInfo *deviceList;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *tipAdjustment;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceTerminaltype;
@property (weak, nonatomic) IBOutlet UILabel *deviceIdentififerLabel;
@property CBCentralManager *cbDeviceManager;
@property CBPeripheral *cbPeripheral;
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
    self.cbDeviceManager = [[CBCentralManager alloc] initWithDelegate: self queue:nil options:nil];

}
/**
 CBManagerStateUnknown = 0,
 CBManagerStateResetting,
 CBManagerStateUnsupported,
 CBManagerStateUnauthorized,
 CBManagerStatePoweredOff,
 CBManagerStatePoweredOn
 */
-(void) beginDeviceSearech {
    switch ([self.cbDeviceManager state]) {
        case 0:
            NSLog(@"Bluetooth device unknown");
            break;
        case 1:
            NSLog(@"Bluetooth device resetting ");
            break;
        case 2:
            NSLog(@"Bluetooth device unsuported");
            break;
        case 3:
            NSLog(@"Bluetooth device unauthorized");
            break;
        case 4:
            NSLog(@"Bluetooth device powered off");
            break;
        case 5:
            NSLog(@"Bluetooth device powered on");
            break;
            
            
        default:
            break;
    }
}

-(void)checkHpaInit {
//    HpsHpaDevice *device = [self setupDevice];
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
//    config.ipAddress
    HpsC2xDevice * device = [[HpsC2xDevice alloc] initWithConfig:config];
    
    return device;
}

- (IBAction)scanButtonTapped:(id)sender {

    [self checkHpaInit];
}
- (IBAction)rescanButtonTapped:(id)sender {

}
-(IBAction)creditSaleButton:(id)sender {

    Float32 amount = [self.amountTextField.text floatValue];

    HpsC2xCreditAuthBuilder *builder = [[HpsC2xCreditAuthBuilder alloc] initWithDevice:self.device];
    builder.amount = [[NSDecimalNumber alloc] initWithDouble: 13];
    
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    
}

//- (void) cen


- (void)onBluetoothDeviceList:(NSMutableArray * _Nonnull)peripherals {
    

    
//    HpsTerminalInfo *device;
    if (peripherals == nil || [peripherals count] == 0) {
        NSLog(@"Peripherals is Empty ");
        NSLog(@"Peripherals is Empty ");
        return;
    }
    
    NSLog(@"Number of Devices %lu",  (unsigned long)[peripherals count]);
    NSLog(@"Number of Devices %lu",  (unsigned long)[peripherals count]);
    self.devicesFound = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < peripherals.count; i++) {
        self.deviceList = [peripherals objectAtIndex:i];
        NSLog(@"Device name : %@", self.deviceList.name);
        NSLog(@"Device : %@c", self.deviceList.identifier);
        NSLog(@"Device connected: %i", self.deviceList.connected);
        NSLog(@"Device desc : %@", self.deviceList.descriptionText);
        NSLog(@"Device terminaType : %@", self.deviceList.terminalType);
        self.deviceNameLabel.text = self.deviceList.name;
        self.deviceTerminaltype.text = self.deviceList.terminalType;
        self.deviceIdentififerLabel.text = [self.deviceList.identifier UUIDString];
        [self.device stopScan];
        [self.device connectDevice: self.deviceList ];
        [self.devicesFound addObject:self.deviceList];
        

    }
    
    
}

- (void)onConnected {
//    [self.device connectDevice: self.deviceList];
    NSLog(@"onConnected");
    NSLog(@"onConnected");
    NSLog(@"onConnected");

}
//6
- (void)onDisconnected {
    NSLog(@"onDisconnected");
    NSLog(@"onDisconnected");
    NSLog(@"onDisconnected");
}

- (void)onError:(NSError * _Nonnull)deviceError {
    NSLog(@"onError %@",deviceError.userInfo);
    NSLog(@"onError %@",deviceError.userInfo);

}



- (void)onConfirmAmount:(NSDecimal)amount {
    
    [self.device confirmAmount:amount];
    NSLog(@"onConfirmAmount");
    NSLog(@"onConfirmAmount");
    Float32 useramount = [self.amountTextField.text floatValue];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirm Amount" message:[NSString stringWithFormat:@"%f", useramount] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)onConfirmApplication:(NSArray<AID *> * _Nonnull)applications {
    
    [self.device confirmApplication:[applications objectAtIndex:0]];
    NSLog(@"onConfirmApplicaiton");
    NSLog(@"onConfirmApplicaiton");
    
    
}


- (void)onTransactionCancelled {
    NSLog(@"onTransactionCancelled");
    NSLog(@"onTransactionCancelled");
    NSLog(@"onTransactionCancelled");
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
    NSLog(@"deviceFound %@", device);
}


- (void)onStatus:(enum HpsTransactionStatus)status {
    NSLog(@"onStatus %lu", (unsigned long)status);
}


- (void)onTransactionComplete:(NSString * _Nonnull)result response:(HpsTerminalResponse * _Nonnull)response {
    NSLog(@"on Transaction Complete ");
}


- (void)requestAIDSelection:(NSArray<AID *> * _Nonnull)applications {
    
}


- (void)requestAmountConfirmation:(NSDecimal)amount {
    NSLog(@"amout ");
}


- (void)requestPostalCode:(NSString * _Nonnull)maskedPan expiryDate:(NSString * _Nonnull)expiryDate cardholderName:(NSString * _Nonnull)cardholderName {
    
}


- (void)requestSaFApproval {
    
}


- (void)searchComplete {
    
}


- (void)onTransactionComplete:(HpsTerminalResponse * _Nonnull)response {
    NSLog(@"onTransactionComplete");
    NSLog(@"onTransactionComplete");
    NSLog(@"onTransactionComplete");
    NSLog(@"TransactionId %@", response.transactionId);
    NSLog(@"TransactionId %@", response.transactionId);
    NSLog(@"TransactionId %@", response.transactionId);
    NSLog(@"Transaction response %@", response.status);
    NSLog(@"Transaction response %@", response.command);

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Transaction" message:@"Transaction Complete" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    //         [alert show];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void)onStatusUpdate:(enum HpsTransactionStatus)transactionStatus {

    NSLog(@"onStatusUpdate %lu", (unsigned long)transactionStatus);

    NSString *status = nil;
    NSMutableArray *resultStatus = [[NSMutableArray alloc] init];
    switch (transactionStatus) {
        case 0:
            status = @"Status Waiting For Configuration";
            break;
        case 1:
            status = @"Status Configuring Terminal";
            break;
        case 2:
            status = @"Status Configuration Failed TryAgain";
            break;
        case 3:
            status = @"Status Ready";
            break;
        case 4:
            status = @"Status Started";
            break;
        case 5:
            status = @"Status Waiting ForCard";
            break;
        case 6:
            status = @"Status Insert Card";
            break;
        case 7:
            status = @"Status Remove Card";
            break;
        case 8:
            status = @"StatusCardRemoved";
            break;
        case 9:
            status = @"StatusPleaseWait";
            break;
        case 10:
            status = @"StatusPleaseSeePhone";
            break;
        case 11:
            status = @"StatusUseMagstripe";
            break;
        case 12:
            status = @"StatusTryAgain";
            break;
        case 13:
            status = @"Status Waiting For Configuration";
            break;
        case 14:
            status = @"Status Waiting For Configuration";
            break;
        case 15:
            status = @"Status Waiting For Configuration";
            break;
        case 16:
            status = @"Status Waiting For Configuration";
            break;
        case 17:
            status = @"Status Waiting For Configuration";
            break;
        case 18:
            status = @"Status Waiting For Configuration";
            break;
        case 19:
            status = @"Status Waiting For Configuration";
            break;
        case 20:
            status = @"Status Waiting For Configuration";
            break;
        case 21:
            status = @"Status Waiting For Configuration";
            break;
        case 22:
            status = @"Status Waiting For Configuration";
            break;
        case 23:
            status = @"Status Waiting For Configuration";
            break;
        case 24:
            status = @"Status Waiting For Configuration";
            break;
        case 25:
            status = @"Transaction Terminated ";
            break;
        case 26:
            status = @"Status Waiting For Configuration";
            break;
        case 27:
            status = @"Status Waiting For Configuration";
            break;
        case 28:
            status = @"Status Waiting For Configuration";
            break;
        case 29:
            status = @"Status Waiting For Configuration";
            break;
        case 30:
            status = @"Status Waiting For Configuration";
            break;
        case 40:
            status = @"Status Waiting For Configuration";
            break;
        case 41:
            status = @"Status Waiting For Configuration";
            break;
        case 42:
            status = @"Status Transaction Complete";
            break;
        case 43:
            status = @"Status Waiting For Configuration";
            break;
        case 44:
            status = @"Status Waiting For Configuration";
            break;
        case 45:
            status = @"Status Waiting For Configuration";
            break;
        case 46:
            status = @"Status Error";
            break;
        case 47:
            status = @"Status Unknown";
            break;
        case 48:
            status = @"Status Terminal Declined ";
            break;
            
        default:
            break;
    }
    [resultStatus addObject:status];
    NSLog(@"Result Status Obj %@", resultStatus);

    
    
}


- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
    NSLog(@"centralManagerDidUpdateState %@ ", central);
    switch ([central state]) {
        case 0:
            NSLog(@"Bluetooth device unknown");
            break;
        case 1:
            NSLog(@"Bluetooth device resetting ");
            break;
        case 2:
            NSLog(@"Bluetooth device unsuported");
            break;
        case 3:
            NSLog(@"Bluetooth device unauthorized");
            break;
        case 4:
            NSLog(@"Bluetooth device powered off");
            break;
        case 5:
            NSLog(@"Bluetooth device powered on");
            break;
            
            
        default:
            break;
    }
}
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
}
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    
}
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"didDiscoverPeripheral");
}

- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral {
    
}
- (void)connectPeripheral:(CBPeripheral *)peripheral options:(nullable NSDictionary<NSString *, id> *)options {
    
}
- (void)stopScan {
    
}
- (void)scanForPeripheralsWithServices:(nullable NSArray<CBUUID *> *)serviceUUIDs options:(nullable NSDictionary<NSString *, id> *)options
{
    
}


@end
