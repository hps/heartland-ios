#import "Record.h"

@implementation Record

-(id)init{
	if (self =  [super init])
	{
		self.Fields = [NSMutableDictionary new];
        self.fieldsValues = [NSMutableArray new];
        self.FieldsArray = [NSMutableArray new];
	}
	return self;
}

- (void) setField:(Field *)field{
    if (field.Value && field.Key) {

        @try {
            [self.FieldsArray addObject:field];
            [self.Fields setValue:field.Value forKey:field.Key];
        }
        @catch (NSException *exception)
        {
            @throw [NSException exceptionWithName:@"HpsHpaException" reason:@"Parsing Exception due to key value" userInfo:nil];
        }
    }
}

@end
