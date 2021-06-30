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

// instance

@property (weak, nonatomic) GMSDevice *device;
@property (nonatomic) NSTimeInterval transactionStartTimestamp;

// computed

@property (strong, nonatomic, readonly) HpsWiseCubeCreditSaleBuilder *sampleCreditSaleBuilder;
@property (strong, nonatomic, readonly) HpsWiseCubeCreditReversalBuilder *sampleCreditReversalBuilder;

@end

@implementation HRGMSTransactionService

- (HpsWiseCubeCreditSaleBuilder *)sampleCreditSaleBuilder {
    return (HpsWiseCubeCreditSaleBuilder *)
    [GMSBaseBuilder builderWithDevice:_device
                                model:
     [GMSBuilderModel creditSaleModelWithAmount:[[NSDecimalNumber alloc] initWithInteger:12]
                                       gratuity:[[NSDecimalNumber alloc] initWithInteger:0]
                                referenceNumber:nil]];
}

- (HpsWiseCubeCreditReversalBuilder *)sampleCreditReversalBuilder {
    return (HpsWiseCubeCreditReversalBuilder *)
    [GMSBaseBuilder builderWithDevice:_device
                                model:
     [GMSBuilderModel creditReversalModelWithAmount:[[NSDecimalNumber alloc] initWithInteger:12]
                                clientTransactionId:nil
                                             reason:ReversalReasonCodeTIMEOUT]];
}

- (instancetype)initWithDevice:(GMSDevice *)device {
    self = [super init];
    if (self) {
        device.transactionDelegate = self;
        _device = device;
    }
    return self;
}

- (void)doSampleCreditReversalWithClientTransactionId:(NSUUID * _Nonnull)clientTransactionId {
    HpsWiseCubeCreditReversalBuilder *builder = self.sampleCreditReversalBuilder;
    builder.clientTransactionId = clientTransactionId;
    [builder execute];
    [self gmsTransactionServiceDidStartTransaction];
}

- (void)doSampleCreditSale {
    [self.sampleCreditSaleBuilder execute];
    [self gmsTransactionServiceDidStartTransaction];
}

- (void)doTransactionWithModel:(GMSBuilderModel *)model {
    [[GMSBaseBuilder builderWithDevice:_device
                                 model:model] execute];
    [self gmsTransactionServiceDidStartTransaction];
}

- (void)gmsTransactionServiceDidStartTransaction {
    _transactionStartTimestamp = NSDate.new.timeIntervalSince1970;
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
    NSLog(@"response received in %d seconds - %@",
          (int)(NSDate.new.timeIntervalSince1970 - _transactionStartTimestamp),
          [HRGMSSerializationService jsonFromGMSObject:response]);
    
    [NSNotificationCenter.defaultCenter postNotificationName:AppNotificationGMSTransactionResponse
                                                      object:response];
    
    if (response.gmsResponseIsTimeout) {
        NSUUID *clientTransactionId = response.clientTransactionIdUUID;
        
        if (!clientTransactionId) {
            NSLog(@"no client transaction id...");
            return;
        };
        
        [self doSampleCreditReversalWithClientTransactionId:clientTransactionId];
    }
}

@end
