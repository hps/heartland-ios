#import "Record.h"

@implementation Record

-(id)init{
	if (self =  [super init])
	{
		self.Fields = [NSMutableDictionary new];
	}
	return self;
}

- (void) setField:(Field *)field{
	if (field.Value && field.Key) {

		@try {
			[self.Fields setValue:field.Value forKey:field.Key];
		}
		@catch (NSException *exception)
		{
		@throw [NSException exceptionWithName:@"HpsHpaException" reason:@"Parsing Exception due to key value" userInfo:nil];
		}
	}
}

@end
