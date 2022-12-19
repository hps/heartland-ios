#import <XCTest/XCTest.h>
#import <Heartland_iOS_SDK/Heartland-iOS-SDK-umbrella.h>
#import <Heartland_iOS_SDK/Heartland_iOS_SDK-Swift.h>

@interface Hps_C2X_Device_Test : XCTestCase<HpsC2xDeviceDelegate,HpsC2xTransactionDelegate>
{
    XCTestExpectation *deviceConnectionExpectation;
    XCTestExpectation *transactionExpectation;
}
@property HpsC2xDevice *device;
@end


@implementation Hps_C2X_Device_Test

-(void)deviceSetUp
{
    HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
    config.versionNumber = @"3409";
    config.developerID = @"002914";
    config.username = @"701389328";
    config.password = @"$Test1234";
    config.siteID = @"142914";
    config.deviceID = @"6399854";
    config.licenseID = @"142827";
    self.device = [[HpsC2xDevice alloc] initWithConfig:config];
}

- (HpsCreditCard*) getCC
{
    HpsCreditCard *card = [[HpsCreditCard alloc] init];
    card.cardNumber = @"4242424242424242";
    card.expMonth = 12;
    card.expYear = 2025;
    card.cvv = @"123";
    return card;
}


- (HpsAddress*) getAddress
{
    HpsAddress *address = [[HpsAddress alloc] init];
    address.address = @"1 Heartland Way";
    address.zip = @"95124";
    return address;
}


-(void)test_initialize
{
    deviceConnectionExpectation = [self expectationWithDescription:@"test_C2X_Initialize"];
    [self deviceSetUp];
    [self.device scan];
    self.device.deviceDelegate = self;
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
               if(error) XCTFail(@"Request Timed out");
                  }];
    XCTAssert(YES, @"Device Connected");
}

#pragma mark - Device Delegate methods
- (void)onConnected //:(HpsTerminalInfo *)terminalInfo
{
    NSLog(@"Device Connected");
    [deviceConnectionExpectation fulfill];

}
- (void)onDisconnected
{
    NSLog(@"Device Disconnected");
}
//- (void)onError:(NSString*)deviceError
//{
//    NSLog(@"%@",deviceError);
//}
- (void)onTerminalInfoReceived:(HpsTerminalInfo *)terminalInfo
{

}
- (void)onBluetoothDeviceList:(NSMutableArray *)peripherals
{
//    for (int i =0; i<self.device.peripherals.count; i++) {
//        CBPeripheral *peripheral = [self.device.peripherals objectAtIndex:i];
//        if ([peripheral.name hasPrefix:@"CHB"]) {
//            [self.device stopScan];
//            [self.device connectDevice:peripheral];
//        }
//    }
}

- (void)onError:(nonnull NSError *)emvError {
}


- (void)onStatusUpdate:(HpsTransactionStatus)transactionStatus {
}
- (void)onConfirmAmount:(NSDecimal)amount {
    
}
- (void)onConfirmApplication:(NSArray<AID *> *)applications {
    
}
- (void)onTransactionComplete:(nonnull HpsTerminalResponse *)response {
}
- (void)onTransactionCancelled {
    
}

@end
