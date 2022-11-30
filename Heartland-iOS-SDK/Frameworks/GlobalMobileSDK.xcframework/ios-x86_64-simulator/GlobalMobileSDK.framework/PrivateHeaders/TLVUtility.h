//
//  TLVUtility.h
//  EMVCore
//

#import <Foundation/Foundation.h>
#import "EMVTagDescriptor.h"

@class Tag;
@class TLVObject;

NS_ASSUME_NONNULL_BEGIN

@interface TLVUtility : NSObject

- (instancetype)init NS_UNAVAILABLE;

+ (nullable NSData *)dataWithHexString:(NSString *)hex;
+ (nullable NSString *)dataToHexString:(NSData *)data;
+ (nullable Tag *)tagFromTLVString:(nullable NSString *)tlvString;
+ (nullable NSString *)tagValueFromTLV:(NSString *)tlv;
+ (nullable NSString *)asciiToHex:(nullable NSString *)string;
+ (nullable NSString *)hexToAscii:(nullable NSString *)hex;
+ (nullable TLVObject *)findTLVObject:(EMVTagDescriptor)tag
                            fromArray:(NSArray<TLVObject *> *)tlvArray;

/**
 Returns complete ICC Data String that will be sent to Host.

 @param emvTags Dictionary of Emv Tags from CardData
 @return concatenated TLV Data String
 */
+ (nullable NSString *)fetchIccDataStringFromEmvTagsDictionary:(nullable NSDictionary<NSString *, NSString *> *)emvTags;

/**
  Returns complete ICC Data String that will be sent to Host.

 @param emvTags Array of Emv Tags from CardData
 @return concatenated TLV Data String
 */
+ (nullable NSString *)fetchIccDataStringFromEmvTagsArray:(nullable NSArray<TLVObject *> *)emvTags;

/**
 This is used to strip down the unnecessary TLV data from Emv Tags array.

 @param tagDescriptors Array of unnecessary TLV data Tag Descriptors
 @param array Array containing all TLV Objects
 @return resulted TLV Objects Array
 */
+ (nullable NSArray<TLVObject *> *)stripTagsEmvTagDescriptors:(nullable NSArray<NSString *> *)tagDescriptors
                                                              fromEmvtags:(nullable NSArray<TLVObject *> *)array;

@end

NS_ASSUME_NONNULL_END
