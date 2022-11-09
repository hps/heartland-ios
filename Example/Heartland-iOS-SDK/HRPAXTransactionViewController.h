//
//  HRPAXTransactionViewController.h
//  Heartland-iOS-SDK_Example
//
//  Created by Desimini, Wilson on 7/9/21.
//  Copyright © 2021 Shaunti Fondrisi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRPAXTransactionViewModelInput.h"
#import "HRPAXTransactionViewModelOutput.h"

NS_ASSUME_NONNULL_BEGIN

@interface HRPAXTransactionViewController : UIViewController <HRPAXTransactionViewModelOutput>

@property (strong, nonatomic) id<HRPAXTransactionViewModelInput> viewModel;

@end

NS_ASSUME_NONNULL_END
