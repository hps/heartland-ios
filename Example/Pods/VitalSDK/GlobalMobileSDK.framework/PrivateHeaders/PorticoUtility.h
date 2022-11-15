//
//  PorticoUtility.h
//  Portico
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PorticoUtility : NSObject

@property (class ,nonatomic, nullable) NSString *originalTransactionIdCopy;

// Class Methods

/**
 Return Base64 encoded String from Hex String.

 @param hexString Hex Formatted String
 @return Base64 format String
 */
+ (NSString *)encodeHexStringToBase64From:(NSString *)hexString;

/**
 Return Hex String decoded from Base64 String.

 @param base64EncodedString Base64 format String
 @return Hex Formatted String
 */
+ (NSString *)decodeBase64ToHexStringFrom:(NSString *)base64EncodedString;

/**
 Locally generated client transaction id can be used as an alternate reference
 to retrieve transactions from the Portico host.

 This is useful in events where the host processes transactions but
 the client fails to receive a response.

 @return String value
 */
+ (nonnull NSString *)generateClientTransactionId;

/**
 This method used to keep a copy of Original Transaction Id.

 @param transactionId String value
 */
+ (void)updateOriginalTransactionIdCopy:(nullable NSString *)transactionId;

/**
 This method used to determine validity of Original Transaction Id.

 @return Bool
 */
+ (BOOL)isOriginalTransactionIdValid;

@end

NS_ASSUME_NONNULL_END
