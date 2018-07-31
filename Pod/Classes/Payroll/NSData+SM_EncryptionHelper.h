#import <Foundation/Foundation.h>

@interface NSData (SM_EncryptionHelper)

- (NSData *)aesDecryptWithKey:(NSData *)key andIV:(NSData *)iv;

- (NSData *)aesEncryptWithKey:(NSData *)key andIV:(NSData *)iv;

- (NSData *)aesEncryptWithPassworkd:(NSString *)password salt:(NSData *)salt;

- (NSData *)aesDecryptWithPassword:(NSString *)password salt:(NSData *)salt;

@end
