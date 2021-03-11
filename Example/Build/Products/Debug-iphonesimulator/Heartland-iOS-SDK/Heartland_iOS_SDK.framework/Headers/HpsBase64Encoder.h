#import <Foundation/Foundation.h>
#import "HpsBase64Encoder.h"

@protocol IRequestEncoder

-(NSString*)encode:(id) value;
-(NSString*)decode:(id) value;

@end

@interface HpsBase64Encoder : NSObject<IRequestEncoder>

@end
