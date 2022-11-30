#import "HpsBase64Encoder.h"

@implementation HpsBase64Encoder


-(id)init {
    
    self = [super init];
    
    if (!self) return nil;
    
    return self;
}

-(NSString*)encode:(id)value {
    
    NSString *strValue = (NSString*)value;
    NSData *data = [strValue dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
    return base64Encoded;
}

-(NSString*)decode:(id)value {
    
    NSString *strValue = (NSString*)value;
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:strValue options:0];
    NSString *base64Decoded = [[NSString alloc]
                               initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
    return base64Decoded;
}

@end
