#import <Foundation/Foundation.h>
#import "HpsPayrollEncoder.h"
#import "HpsJsonDoc.h"

@interface HpsPayrollEntity : NSObject

-(void)fromJSON:(HpsJsonDoc *)doc withArgument:(HpsPayrollEncoder *)encoder;

@end
