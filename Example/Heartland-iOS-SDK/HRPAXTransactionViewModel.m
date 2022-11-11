//
//  HRPAXTransactionViewModel.m
//  Heartland-iOS-SDK_Example
//
//  Created by Desimini, Wilson on 7/9/21.
//  Copyright © 2021 Shaunti Fondrisi. All rights reserved.
//

#import "HRPAXTransactionViewModel.h"

@interface HRPAXTransactionViewModel ()

@property (strong, nonatomic) NSDecimalNumber *amount;
@property (strong, nonatomic) NSString *deviceIPAddress;

- (int)newECRRef;

@end

@implementation HRPAXTransactionViewModel

// MARK: Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        _amount = [NSDecimalNumber decimalNumberWithString:@"12.00"];
        _deviceIPAddress = @"192.168.0.21";
    }
    return self;
}

// MARK: HRPAXTransactionModelOutput

- (void)didCompletePAXTransactionWithResponse:(nullable HpsPaxCreditResponse *)response
                                        error:(nullable NSError *)error {
    NSMutableString *prompt = [NSMutableString stringWithString:@"PAX Transaction Complete"];
    
    if (error) {
        [prompt appendFormat:@"\nError:\n%@", error.localizedDescription];
    } else if (response) {
        [prompt appendFormat:@"\nResponse:\n%@", response];
    }
    
    [_output showPAXTransactionCompleteWithPrompt:prompt];
}

// MARK: HRPAXTransactionViewModelInput

- (void)doTransaction {
    [_output showPAXTransactionInProgress];
    
    [_model doTransactionWithAmount:_amount
                    deviceIPAddress:_deviceIPAddress
                             ecrRef:self.newECRRef];
}

// MARK: Utilities

- (int)newECRRef {
    return (int)NSDate.new.timeIntervalSince1970;
}

@end
