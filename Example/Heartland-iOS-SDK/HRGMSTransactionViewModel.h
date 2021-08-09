//
//  HRGMSTransactionViewModel.h
//  Heartland-iOS-SDK_Example
//
//  Created by Desimini, Wilson on 6/17/21.
//  Copyright © 2021 Shaunti Fondrisi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Heartland_iOS_SDK/Heartland_iOS_SDK-Swift.h>
#import <Heartland_iOS_SDK/HpsTerminalResponse.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HRGMSTransactionView <NSObject>

- (void)gmsTransactionViewDisplayResponseBody:(NSString *)bodyText;
- (void)gmsTransactionViewDisplayResponseError:(NSString *)errorMessage;
- (void)gmsTransactionViewDisplayResponseSuccess;
- (void)gmsTransactionViewDisplayStatus:(NSString *)status;
- (void)gmsTransactionViewResetResponseViews;

@end

@interface HRGMSTransactionViewModel : NSObject

@property (weak, nonatomic) id<HRGMSTransactionView> view;

- (void)gmsReturnSelected;
- (void)gmsSaleSelected;

@end

NS_ASSUME_NONNULL_END
