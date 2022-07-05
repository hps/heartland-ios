//
//  HpsUPAParser.h
//  Heartland-iOS-SDK
//
//  Created by Desimini, Wilson on 7/1/22.
//

#import <Foundation/Foundation.h>
#import "UpaEnums.h"

@protocol IHPSDeviceMessage;

NS_ASSUME_NONNULL_BEGIN

@interface HpsUPAParser : NSObject

+ (NSData *)dataFromUPARaw:(NSData *)data;
+ (NSString *)descriptionOfMessageType:(UPA_MSG_TYPE)messageType;
+ (NSDictionary *)jsonfromUPARaw:(NSData *)data;
+ (NSString *)jsonStringFromUPARaw:(NSData *)data;
+ (UPA_MSG_TYPE)messageTypeFromUPARaw:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
