//
//  TLVDecoder.h
//  EMVCore
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TLVObject;

@interface TLVDecoder : NSObject

+ (nullable NSArray<TLVObject *> *)decodeWithTLVString:(nullable NSString*)tlv;
+ (int)hexToInt:(nullable NSString*)hex;

@end

NS_ASSUME_NONNULL_END
