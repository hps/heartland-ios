//
//  HRPAXTransactionManager.m
//  Heartland-iOS-SDK_Example
//
//  Created by Desimini, Wilson on 7/9/21.
//  Copyright © 2021 Shaunti Fondrisi. All rights reserved.
//

#import "HRPAXTransactionManager.h"
#import <Heartland_iOS_SDK/HpsPaxCreditSaleBuilder.h>
#import <Heartland_iOS_SDK/HpsPaxDevice.h>

@interface HRPAXTransactionManager ()

- (HpsPaxCreditSaleBuilder *)paxCreditSaleBuilderWithDevice:(HpsPaxDevice *)device;
- (HpsPaxDevice *)paxDeviceWithIPAddress:(NSString *)ipAddress;

@end

@implementation HRPAXTransactionManager

// MARK: HRPAXTransactionModelInput

- (void)doTransactionWithAmount:(nonnull NSDecimalNumber *)amount
                deviceIPAddress:(nonnull NSString *)deviceIPAddress
                         ecrRef:(int)ecrRef {
    NSLog(@"executing transaction for amount: %@", amount);
    
    HpsPaxCreditSaleBuilder *builder = [self paxCreditSaleBuilderWithDevice:
                                        [self paxDeviceWithIPAddress:deviceIPAddress]];
    builder.allowDuplicates = NO;
    builder.amount = amount;
    builder.referenceNumber = ecrRef;
    builder.requestMultiUseToken = YES;
    builder.tipRequest = YES;
    
    __weak HRPAXTransactionManager *welf = self;
    
    [builder execute:^(HpsPaxCreditResponse *response, NSError *error) {
        [welf.output didCompletePAXTransactionWithResponse:response error:error];
    }];
}

// MARK: Utilities

- (HpsPaxCreditSaleBuilder *)paxCreditSaleBuilderWithDevice:(HpsPaxDevice *)device {
    return [[HpsPaxCreditSaleBuilder alloc] initWithDevice:device];
                
}

- (HpsPaxDevice *)paxDeviceWithIPAddress:(NSString *)ipAddress {
    HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
    config.ipAddress = ipAddress;
    config.port = @"10009";
    config.connectionMode = HpsConnectionModes_HTTP;
    return [[HpsPaxDevice alloc] initWithConfig:config];
}

@end
