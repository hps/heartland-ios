#import "HpsAddress.h"

@implementation HpsAddress

-(void)isZipcodeValid {

	NSString *strZipRegex = @"^[0-9]{5}(?:[-\\s][0-9]{4})?$";

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",strZipRegex];

	if (![predicate evaluateWithObject:self.zip]) {
		@throw [NSException exceptionWithName:@"HpsAddressException" reason:@"Zipcode is not valid." userInfo:nil];
	}
}

@end
