#import "Rfc2898DeriveBytes.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import "NSData+SM_EncryptionHelper.h"

const NSInteger rounds = 1000;

@implementation Rfc2898DeriveBytes

+ (void)deriveBytes:(NSMutableData *)deriveBytes fromPassword:(NSString *)password andSalt:(NSData *)salt{
    
    
    
    [deriveBytes setLength:(kCCKeySizeAES256+kCCBlockSizeAES128)];
    
    int result = CCKeyDerivationPBKDF(kCCPBKDF2,
                                      password.UTF8String,
                                      [password lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
                                      salt.bytes,
                                      salt.length,
                                      kCCPRFHmacAlgSHA1,
                                      rounds,
                                      deriveBytes.mutableBytes,
                                      (kCCKeySizeAES256+kCCBlockSizeAES128));
    
   

    if (result != kCCSuccess) {
        NSLog(@"can't generate the AES derivedKey");
        return;
    }
    
    

}

+ (void)deriveKey:(NSMutableData *)key andIV:(NSMutableData *)iv fromPassword:(NSString *)password andSalt:(NSData *)salt{
    
    NSMutableData *derivedKey = [NSMutableData dataWithLength:(kCCKeySizeAES256+kCCBlockSizeAES128)];
    
    [key setLength:kCCKeySizeAES256];
    
    [iv setLength:kCCBlockSizeAES128];
    
    [self deriveBytes:derivedKey fromPassword:password andSalt:salt];
    
    [derivedKey getBytes:[key mutableBytes] range:NSMakeRange(0, kCCKeySizeAES256)];
    [derivedKey getBytes:[iv mutableBytes] range:NSMakeRange(kCCKeySizeAES256, kCCBlockSizeAES128)];
}

@end
