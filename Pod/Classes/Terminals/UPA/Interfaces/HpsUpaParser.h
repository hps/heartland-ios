//
//  HpsUpaParser.h
//  Heartland-iOS-SDK
//
//  Created by Desimini, Wilson on 7/1/22.
//

#import <Foundation/Foundation.h>
#import "UpaEnums.h"

@interface HpsUpaParser : NSObject

+ (NSData *)dataFromUPARaw:(NSData *)data;
+ (NSDictionary *)jsonfromUPARaw:(NSData *)data;
+ (NSString *)jsonStringFromUPARaw:(NSData *)data;
+ (NSString *)descriptionOfMessageType:(UPA_MSG_TYPE)messageType;
+ (UPA_MSG_TYPE)messageTypeFromUPARaw:(NSData *)data;

@end
