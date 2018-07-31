#import "HpsPayrollEncoder.h"
#import "NSData+SM_EncryptionHelper.h"

@implementation HpsPayrollEncoder

-(id)init {
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.username = @"testapiuser.russell";
    self.apiKey = @"iGF9UtaLc526poWWNgUpiCoO3BckcZUKNF3nhyKul8A=";
    
    return self;
}

-(NSString*)encode:(id)value {
    
    if (value == nil) {
        return nil;
    }

    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
    data = [data aesEncryptWithPassworkd:self.apiKey salt:[self.username dataUsingEncoding:NSUTF8StringEncoding]];
   
    NSString *strBase64 = [data base64EncodedStringWithOptions:0];
    
    return strBase64;
    
}

-(NSString*)decode:(id)value {
    
    if (value == nil) {
        return nil;
    }
    
    NSString *strBase64 = [NSString stringWithString:value];
    NSData *encryptedData = [[NSData alloc] initWithBase64EncodedString:strBase64 options:0];
    NSData *decryptedData = [encryptedData aesDecryptWithPassword:self.apiKey salt:[self.username dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *strDecoded = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    
    return strDecoded;
}

@end
