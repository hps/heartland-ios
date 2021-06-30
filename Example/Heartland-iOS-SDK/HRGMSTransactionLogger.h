//
//  HRGMSTransactionLogger.h
//  Heartland-iOS-SDK_Example
//
//  Created by Desimini, Wilson on 6/30/21.
//  Copyright © 2021 Shaunti Fondrisi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HpsTerminalResponse;

NS_ASSUME_NONNULL_BEGIN

@interface HRGMSTransactionLogger : NSObject

+ (void)logTransactionCompleteWithResponse:(HpsTerminalResponse *)response
                            startTimestamp:(NSTimeInterval)startTimestamp
                              targetAmount:(NSDecimalNumber *)targetAmount;

@end

NS_ASSUME_NONNULL_END
