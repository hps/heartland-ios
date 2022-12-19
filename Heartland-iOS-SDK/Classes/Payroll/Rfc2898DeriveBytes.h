#import <Foundation/Foundation.h>

@interface Rfc2898DeriveBytes : NSObject

+(void)deriveBytes:(NSMutableData *)deriveBytes
      fromPassword:(NSString *)password andSalt:(NSData *)salt;;

+(void)deriveKey:(NSMutableData *)key andIV:(NSMutableData *)iv
    fromPassword:(NSString *)password andSalt:(NSData *)salt;

@end
