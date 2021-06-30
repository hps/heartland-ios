//
//  HRGMSTransactionService.m
//  Heartland-iOS-SDK_Example
//
//  Created by Desimini, Wilson on 6/17/21.
//  Copyright © 2021 Shaunti Fondrisi. All rights reserved.
//

#import "HRGMSTransactionLogger.h"
#import "HRGMSTransactionService.h"
#import "HRGMS+Notifications.h"
#import "HRGMSSerializationService.h"
#import <Heartland_iOS_SDK/Heartland_iOS_SDK-Swift.h>

@interface HRGMSTransactionService ()

// instance

@property (weak, nonatomic) GMSDevice *device;
@property (nonatomic) NSTimeInterval transactionStartTimestamp;
@property (strong, nonatomic) NSDecimalNumber *transactionTargetAmount;

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

- (void)doCreditReversalWithClientTransactionId:(NSUUID * _Nonnull)clientTransactionId {
    HpsWiseCubeCreditReversalBuilder *builder =
    (HpsWiseCubeCreditReversalBuilder *)
    [GMSBaseBuilder builderWithDevice:_device
                                model:
     [GMSBuilderModel creditReversalModelWithAmount:_transactionTargetAmount
                                clientTransactionId:clientTransactionId
                                             reason:ReversalReasonCodeTIMEOUT]];
    
    [builder execute];
    
    [self gmsTransactionServiceDidStartTransactionForAmount:builder.amount];
}

- (void)doTransactionWithModel:(GMSBuilderModel *)model {
    [[GMSBaseBuilder builderWithDevice:_device
                                 model:model] execute];
    [self gmsTransactionServiceDidStartTransactionForAmount:model.amount];
}

- (void)gmsTransactionServiceDidStartTransactionForAmount:(NSDecimalNumber *)amount {
    _transactionStartTimestamp = NSDate.new.timeIntervalSince1970;
    _transactionTargetAmount = amount;
}

// MARK: GMSTransactionDelegate

- (void)onConfirmAmount:(NSDecimal)amount {
    [_device.gmsWrapper confirmAmountWithAmount:amount];
}

- (void)onConfirmApplication:(NSArray<AID *> * _Nonnull)applications {
    [_device confirmApplication:applications[0]];
}

- (void)onTransactionError:(NSError * _Nonnull)error {
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
    [HRGMSTransactionLogger logTransactionCompleteWithResponse:response
                                                startTimestamp:_transactionStartTimestamp
                                                  targetAmount:_transactionTargetAmount];
    
    [NSNotificationCenter.defaultCenter postNotificationName:AppNotificationGMSTransactionResponse
                                                      object:response];
    
    if (response.gmsResponseIsReversible) {
        [self doCreditReversalWithClientTransactionId:
         response.clientTransactionIdUUID];
    }
}

@end
