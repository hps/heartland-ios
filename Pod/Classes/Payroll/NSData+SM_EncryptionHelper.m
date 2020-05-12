#import "NSData+SM_EncryptionHelper.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import "Rfc2898DeriveBytes.h"

@implementation NSData (SM_EncryptionHelper)

- (NSData *)aesDecryptWithKey:(NSData *)key andIV:(NSData *)iv{
    
    CCCryptorRef __cryptor;
    
    CCCryptorStatus
    cryptorStatus = CCCryptorCreate(kCCDecrypt,
                                    kCCAlgorithmAES128,
                                    kCCOptionPKCS7Padding,
                                    key.bytes,
                                    key.length,
                                    iv.bytes,
                                    &__cryptor);
    
    if (cryptorStatus != kCCSuccess) {
        NSLog(@"can't generate the AES cryptor");
        return nil;
    }
    
    NSMutableData *outdata = [[NSMutableData alloc] initWithLength:36];
    [outdata setLength:CCCryptorGetOutputLength(__cryptor, [self length], true)];
    
    
    NSMutableData *buffer = outdata;
    size_t dataOutMoved;
    
    CCCryptorStatus cryptStatuslast = CCCrypt(kCCDecrypt,
                                              kCCAlgorithmAES,
                                              kCCOptionPKCS7Padding,
                                              key.bytes,
                                              key.length,
                                              iv.bytes,
                                              self.bytes,
                                              self.length,
                                              outdata.mutableBytes,
                                              outdata.length, &dataOutMoved);
    if (cryptStatuslast == kCCSuccess) {
        return [buffer subdataWithRange:NSMakeRange(0, dataOutMoved)];
    }else{
        return nil;
    }
    
}

- (NSData *)aesEncryptWithKey:(NSData *)key andIV:(NSData *)iv{
    CCCryptorRef __cryptor;
    
    CCCryptorStatus
    cryptorStatus = CCCryptorCreate(kCCEncrypt,
                                    kCCAlgorithmAES128,
                                    kCCOptionPKCS7Padding,
                                    key.bytes,
                                    key.length,
                                    iv.bytes,
                                    &__cryptor);
    
    if (cryptorStatus != kCCSuccess) {
        NSLog(@"can't generate the AES cryptor");
        return nil;
    }
    
    NSMutableData *outdata = [NSMutableData dataWithLength:[self length]];
    [outdata setLength:CCCryptorGetOutputLength(__cryptor, [self length], true)];
    
    
    NSMutableData *buffer = outdata;
    size_t dataOutMoved;
    
    CCCryptorStatus cryptStatuslast = CCCrypt(kCCEncrypt,
                                              kCCAlgorithmAES,
                                              kCCOptionPKCS7Padding,
                                              key.bytes,
                                              key.length,
                                              iv.bytes,
                                              self.bytes,
                                              self.length,
                                              outdata.mutableBytes,
                                              outdata.length, &dataOutMoved);
    if (cryptStatuslast == kCCSuccess) {
        return [buffer subdataWithRange:NSMakeRange(0, dataOutMoved)];
    }else{
        return nil;
    }
}

- (NSData *)aesDecryptWithPassword:(NSString *)password salt:(NSData *)salt{
    
    NSMutableData *key = [NSMutableData dataWithLength:kCCKeySizeAES256];
    NSMutableData *iv = [NSMutableData dataWithLength:kCCBlockSizeAES128];
    
    [Rfc2898DeriveBytes deriveKey:key andIV:iv fromPassword:password andSalt:salt];
    
    NSData *decryptData = [self aesDecryptWithKey:key andIV:iv];
    return decryptData;
}

- (NSData *)aesEncryptWithPassworkd:(NSString *)password salt:(NSData *)salt{
    
    NSMutableData *key = [NSMutableData dataWithLength:kCCKeySizeAES256];
    NSMutableData *iv = [NSMutableData dataWithLength:kCCBlockSizeAES128];
    
    [Rfc2898DeriveBytes deriveKey:key andIV:iv fromPassword:password andSalt:salt];
    
    NSData *encryptData = [self aesEncryptWithKey:key andIV:iv];
    
    return encryptData;
}




@end
