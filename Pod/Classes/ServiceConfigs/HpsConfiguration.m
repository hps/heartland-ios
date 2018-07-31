#import "HpsConfiguration.h"

@implementation HpsConfiguration

- (void) Validate
{
	self.Validated = YES;
}

-(void)ConfigureContainer:(HpsConfiguredServices *)serives{
	[NSException raise:NSInternalInconsistencyException format:@"Method Not Implememnted %@ in %@",NSStringFromSelector(_cmd),NSStringFromClass([self class])];
}

@end
