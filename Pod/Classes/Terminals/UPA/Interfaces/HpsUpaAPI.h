//
//  HpsUpaAPI.h
//  Heartland-iOS-SDK
//
//  Created by Desimini, Wilson on 7/1/22.
//

#import <Foundation/Foundation.h>
#import "UpaEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface HpsUpaAPI : NSObject

+ (NSData * _Nullable)dataFromUPARaw:(NSData *)data;
+ (NSDictionary * _Nullable)jsonfromUPARaw:(NSData *)data;
+ (UPA_MSG_TYPE)upaMessageTypeFromUPARaw:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
