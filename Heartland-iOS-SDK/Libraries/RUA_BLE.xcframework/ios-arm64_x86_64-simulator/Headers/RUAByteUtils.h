/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

static char base64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

@interface RUAByteUtils : NSObject

/**
 Converts Hexadecimal string to NSData
 @param hexString Hexadecimal string
 @return NSData representation of the string
 */
+ (NSData *)convertHexString:(NSString *)hexString;

/**
 Converts NSData string to Hexadecimal string
 @param data NSData representation of the string
 @return Hexadecimal string
 */
+ (NSString *)convertNSDatatoHexadecimal:(NSData *)data;

/**
 Converts ByteArray string to Hexadecimal string
 @param data Byte array
 @param length Length
 @return Hexadecimal string
 */
+ (NSString *)convertByteArraytoHexadecimal:(Byte *)data withLength:(int)length;

/**
 Converts NSData to ASCII string
 @param data NSData representation of the string
 @return ASCII string
 */
+ (NSString *)convertNSDATAtoASCIIString:(NSData *)data;

/**
 Converts NSData to ASCII string
 @param data NSData representation of the string
 @param shouldMaskNullCharacter bool should mask null character with asterisk
 @return ASCII string
 */
+ (NSString *)convertNSDATAtoASCIIString:(NSData *)data andShouldMaskNullCharacter:(bool)shouldMaskNullCharacter;

/**
 Converts Hex String to ASCII string
 @param hexString Hexadecimal string
 @return ASCII String
 */
+ (NSString *)convertHexStringtoASCIIString:(NSString *)hexString;

/**
 Converts ASCII string to Hex String
 @param str ASCII string
 @return Hexadecimal String
 */
+ (NSString *) convertASCIIStringToHexString:(NSString *)str;

/**
 Converts Data to Base 64 encoded string
 @param data NSData representation of the string
 @return Base 64 encoded string
 */
+ (NSString *) base64EncodedStringFromData:(NSData *)data;

/**
 Converts Hex String to Base 64 encoded string
 @param hexString Hexadecimal string
 @return Base 64 encoded string
 */
+ (NSString *) base64EncodedStringFromHexadecimalString: (NSString *) hexString;

+ (int) NSDataToInt:(NSData *)data;

+ (NSString *)getStringFromNSData:(NSData *)data
                        fromIndex:(int)index
                       withLength:(int)length;
                       
+ (int)byteArrayToInt:(Byte[])b withLength:(int)len;

+ (NSString *) calculateLrc:(NSString *) dataStr;

+ (NSString *) removeNonAsciiCharacters:(NSString *) sourceStr;

@end
