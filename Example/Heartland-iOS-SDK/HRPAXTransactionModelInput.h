//
//  HRPAXTransactionModelInput.h
//  Heartland-iOS-SDK_Example
//
//  Created by Desimini, Wilson on 7/9/21.
//  Copyright © 2021 Shaunti Fondrisi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HRPAXTransactionModelInput <NSObject>

- (void)doTransactionWithAmount:(NSDecimalNumber *)amount
                deviceIPAddress:(NSString *)deviceIPAddress
                         ecrRef:(int)ecrRef;

@end

NS_ASSUME_NONNULL_END