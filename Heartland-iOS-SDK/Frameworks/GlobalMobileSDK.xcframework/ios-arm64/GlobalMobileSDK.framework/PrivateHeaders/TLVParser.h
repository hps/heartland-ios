//
//  TLVParser.h
//  EMVCore
//

#import <UIKit/UIKit.h>

@class Tag;
@class TLVObject;
@class TerminalTender;

@interface TLVParser : NSObject

/**
 This method is used to split the unified TLV string() into multiple individual TLV strings.

 @param tlvString NSString, Initial TLV string
 @return List of TLV strings
 */
+ (nullable NSArray <NSString *> *)splitTLVData:(nullable NSString *)tlvString;

/**
 This method is used to split the Unified TLV string into TLV objects.

 @param tlvString NSString, Initial TLV string
 @return List of TLV objcts
 */
+ (nullable NSArray <TLVObject *> *)tlvObjectsFromTLVData:(nullable NSString *)tlvString;

+(BOOL)isIssuerScriptTemplate1:(nonnull NSString *)tlv;

+(BOOL)isIssuerScriptTemplate2:(nonnull NSString *)tlv;

+ (nullable NSArray <NSString *> *)cleanTagsForGateway:(nonnull TerminalTender *)tender;

@end
