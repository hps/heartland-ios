#import "NSMutableDictionary+ShiftAssignments.h"

@implementation NSMutableDictionary (ShiftAssignments)

-(NSString *)toString{
	NSString *key ;
	NSString *sb = @"";
	for ( key in [self allKeys]) {
		sb = [sb stringByAppendingString:[NSString stringWithFormat:@"%@-",key]];
		sb = [sb stringByAppendingString:[NSString stringWithFormat:@"%@",[self objectForKey:key]]];
		sb = [sb stringByAppendingString:@"|"];
	}
	return sb;
}

@end
