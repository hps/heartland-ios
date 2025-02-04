/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import "RUASystemLanguage.h"

@interface RUASystemLanguageHelper : NSObject

/**
 Return hexidecimal representation of the RUASystemLanguage
 @param RUASystemLanguage language
 @return Hex String value of the RUASystemLanguage
 */
+ (NSString *)getLanguageHexString:(RUASystemLanguage) language;

@end
