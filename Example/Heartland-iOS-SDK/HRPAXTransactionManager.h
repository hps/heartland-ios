//
//  HRPAXTransactionManager.h
//  Heartland-iOS-SDK_Example
//
//  Created by Desimini, Wilson on 7/9/21.
//  Copyright © 2021 Shaunti Fondrisi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRPAXTransactionModelInput.h"
#import "HRPAXTransactionModelOutput.h"

NS_ASSUME_NONNULL_BEGIN

@interface HRPAXTransactionManager : NSObject <HRPAXTransactionModelInput>

@property (weak, nonatomic) id<HRPAXTransactionModelOutput> output;

@end

NS_ASSUME_NONNULL_END
