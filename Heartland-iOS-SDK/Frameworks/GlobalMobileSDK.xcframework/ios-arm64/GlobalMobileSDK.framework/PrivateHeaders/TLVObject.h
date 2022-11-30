//
//  TLVObject.h
//  EMVCore
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLVObject : NSObject

#pragma mark Methods

- (nonnull instancetype)initWithString:(nonnull NSString *)tlvTag;
+ (nullable NSString *)generateHexStringFromTLVObject:(nullable TLVObject *)tlvObject;

#pragma mark Properties

@property (nonatomic, copy, nonnull) NSString *tagName;
@property (nonatomic, copy, nonnull) NSString *tag;
@property (nonatomic, copy, nullable) NSString *length;
@property (nonatomic, copy, nullable) NSString *value;
@property (nonatomic, copy, nullable) NSArray<TLVObject *> *innerTlvs;

@end

NS_ASSUME_NONNULL_END
