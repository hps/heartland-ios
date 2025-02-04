/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

@interface RUAPublicKey : NSObject

/**
 * RID - Registered Application Provider Identifier
 * */
@property NSString *rid;
/**
 * Certification Authority Public Key Index
 * */
@property NSString *caPublicKeyIndex;
/**
 * Public Key
 * */
@property NSString *publicKey;
/**
 * Exponent of Public Key
 * */
@property NSString *exponentOfPublicKey;
/**
 * Checksum of Public key
 * */
@property NSString *checksum;

- (id)          initWithRID:(NSString *)rid
       withCAPublicKeyIndex:(NSString *)CAPublicKeyIndex
              withPublicKey:(NSString *)PublicKey
    withExponentOfPublicKey:(NSString *)ExponentOfPublicKey;

- (id)          initWithRID:(NSString *)rid
       withCAPublicKeyIndex:(NSString *)CAPublicKeyIndex
              withPublicKey:(NSString *)PublicKey
    withExponentOfPublicKey:(NSString *)ExponentOfPublicKey
               withChecksum:(NSString *)checksum;

- (NSString *)getFormattedString;

@end
