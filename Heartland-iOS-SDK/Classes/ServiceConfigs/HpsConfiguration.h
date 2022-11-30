#import <Foundation/Foundation.h>
#import "HpsConfiguredServices.h"

static NSInteger timeoutValue  = 65000;

@interface HpsConfiguration : NSObject

@property  NSString *serviceUrl;
@property Boolean Validated;

-(void) ConfigureContainer:(HpsConfiguredServices *)serives;
-(void) Validate;

@end
