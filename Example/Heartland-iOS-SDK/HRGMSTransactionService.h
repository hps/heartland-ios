//
//  HRGMSTransactionService.h
//  Heartland-iOS-SDK_Example
//
//  Created by Desimini, Wilson on 6/17/21.
//  Copyright © 2021 Shaunti Fondrisi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Heartland_iOS_SDK/Heartland_iOS_SDK-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface HRGMSTransactionService : NSObject <GMSTransactionDelegate>

- (instancetype)initWithDevice:(GMSDevice *)device;

- (void)doTransactionWithModel:(GMSBuilderModel *)model;

@end

NS_ASSUME_NONNULL_END
