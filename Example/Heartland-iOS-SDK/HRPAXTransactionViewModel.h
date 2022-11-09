//
//  HRPAXTransactionViewModel.h
//  Heartland-iOS-SDK_Example
//
//  Created by Desimini, Wilson on 7/9/21.
//  Copyright © 2021 Shaunti Fondrisi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRPAXTransactionModelInput.h"
#import "HRPAXTransactionModelOutput.h"
#import "HRPAXTransactionViewModelInput.h"
#import "HRPAXTransactionViewModelOutput.h"

NS_ASSUME_NONNULL_BEGIN

@interface HRPAXTransactionViewModel : NSObject <
HRPAXTransactionModelOutput,
HRPAXTransactionViewModelInput
>

@property (strong, nonatomic) id<HRPAXTransactionModelInput> model;
@property (weak, nonatomic) id<HRPAXTransactionViewModelOutput> output;

@end

NS_ASSUME_NONNULL_END
