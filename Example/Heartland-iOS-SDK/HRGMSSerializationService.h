//
//  HRGMSSerializationService.h
//  Heartland-iOS-SDK_Example
//
//  Created by Desimini, Wilson on 6/17/21.
//  Copyright © 2021 Shaunti Fondrisi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Heartland_iOS_SDK/HpsTerminalResponse.h>

NS_ASSUME_NONNULL_BEGIN

@interface HRGMSSerializationService : NSObject

+ (NSMutableDictionary *)transactionDetailJSONFromResponse:(HpsTerminalResponse *)response;
+ (NSDictionary *)jsonFromGMSObject:(id)gmsObject;

@end

NS_ASSUME_NONNULL_END
