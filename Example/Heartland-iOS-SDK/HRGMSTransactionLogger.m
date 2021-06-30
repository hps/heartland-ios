//
//  HRGMSTransactionLogger.m
//  Heartland-iOS-SDK_Example
//
//  Created by Desimini, Wilson on 6/30/21.
//  Copyright © 2021 Shaunti Fondrisi. All rights reserved.
//

#import "HRGMSTransactionLogger.h"
#import "HRGMSSerializationService.h"

@implementation HRGMSTransactionLogger

+ (void)logTransactionCompleteWithResponse:(HpsTerminalResponse *)response
                            startTimestamp:(NSTimeInterval)startTimestamp
                              targetAmount:(nonnull NSDecimalNumber *)targetAmount
{
    NSLog(@"response received in %d seconds - %@",
          (int)(NSDate.new.timeIntervalSince1970 - startTimestamp),
          [HRGMSSerializationService jsonFromGMSObject:response]);
    
    NSString *(^descriptionOfBOOL)(BOOL) = ^(BOOL obj){
        return obj ? @"yes" : @"no";
    };
    
    NSLog(@"approvedAmount - %@", response.approvedAmount.stringValue);
    NSLog(@"approvedAmount accurate? - %@",
          descriptionOfBOOL([response.approvedAmount isEqualToNumber:
                             targetAmount]));
    NSLog(@"approvedAmount.stringValue accurate? - %@",
          descriptionOfBOOL([response.approvedAmount.stringValue isEqualToString:
                             targetAmount.stringValue]));
}

@end
