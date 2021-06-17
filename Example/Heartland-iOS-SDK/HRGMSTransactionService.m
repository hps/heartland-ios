//
//  HRGMSTransactionService.m
//  Heartland-iOS-SDK_Example
//
//  Created by Desimini, Wilson on 6/17/21.
//  Copyright © 2021 Shaunti Fondrisi. All rights reserved.
//

#import "HRGMSTransactionService.h"
#import "HRGMS+Notifications.h"
#import "HRGMSSerializationService.h"
#import <Heartland_iOS_SDK/Heartland_iOS_SDK-Swift.h>

@interface HRGMSTransactionService ()

@property (weak, nonatomic) GMSDevice *device;
@property (nonatomic) NSTimeInterval transactionStartTimestamp;

@end

@implementation HRGMSTransactionService

- (instancetype)initWithDevice:(GMSDevice *)device {
    self = [super init];
    if (self) {
        device.transactionDelegate = self;
        _device = device;
    }
    return self;
}

- (HpsWiseCubeCreditSaleBuilder *)sampleCreditSaleBuilder {
    HpsWiseCubeCreditSaleBuilder *builder =
    [[HpsWiseCubeCreditSaleBuilder alloc] initWithDevice:
     (HpsWiseCubeDevice *)_device];
    builder.amount = [[NSDecimalNumber alloc] initWithInteger:12];
    builder.gratuity = [[NSDecimalNumber alloc] initWithInteger:0];
    return builder;
}

- (void)doSampleCreditSale {
    _transactionStartTimestamp = NSDate.new.timeIntervalSince1970;
    [self.sampleCreditSaleBuilder execute];
}

// MARK: GMSTransactionDelegate

- (void)onConfirmAmount:(NSDecimal)amount {
    [_device.gmsWrapper confirmAmountWithAmount:amount];
}

- (void)onConfirmApplication:(NSArray<AID *> * _Nonnull)applications {
    [_device confirmApplication:applications[0]];
}

- (void)onError:(NSError * _Nonnull)error {
    [NSNotificationCenter.defaultCenter postNotificationName:AppNotificationGMSTransactionError
                                                      object:error];
}

- (void)onStatusUpdate:(enum HpsTransactionStatus)transactionStatus {
    [NSNotificationCenter.defaultCenter postNotificationName:AppNotificationGMSTransactionStatus
                                                      object:@(transactionStatus)];
}

- (void)onTransactionCancelled {
    [NSNotificationCenter.defaultCenter postNotificationName:AppNotificationGMSTransactionResponse
                                                      object:nil];
}

- (void)onTransactionComplete:(HpsTerminalResponse * _Nonnull)response {
    NSLog(@"response received in %d seconds - %@",
          (int)(NSDate.new.timeIntervalSince1970 - _transactionStartTimestamp),
          [HRGMSSerializationService jsonFromGMSObject:response]);
    
    [NSNotificationCenter.defaultCenter postNotificationName:AppNotificationGMSTransactionResponse
                                                      object:response];
}

@end
