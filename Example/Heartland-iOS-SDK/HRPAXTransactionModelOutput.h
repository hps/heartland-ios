//
//  HRPAXTransactionModelOutput.h
//  Heartland-iOS-SDK_Example
//
//  Created by Desimini, Wilson on 7/9/21.
//  Copyright © 2021 Shaunti Fondrisi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HpsPaxCreditResponse;

NS_ASSUME_NONNULL_BEGIN

@protocol HRPAXTransactionModelOutput <NSObject>

- (void)didCompletePAXTransactionWithResponse:(nullable HpsPaxCreditResponse *)response
                                        error:(nullable NSError *)error;

@end

NS_ASSUME_NONNULL_END
