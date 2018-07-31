#import <Foundation/Foundation.h>
#import "HpsBase64Encoder.h"

@interface HpsPayrollEncoder : NSObject<IRequestEncoder>

@property (nonatomic,strong) NSString* username;
@property (nonatomic,strong) NSString* apiKey;
@property (nonatomic,strong) NSData* iv;
@property (nonatomic,strong) NSData* salt;

@end
