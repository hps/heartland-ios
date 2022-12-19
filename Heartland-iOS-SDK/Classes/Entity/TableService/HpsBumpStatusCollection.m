#import "HpsBumpStatusCollection.h"

@implementation HpsBumpStatusCollection

-(id)initWithBumpStatusCollectoion:(NSString *)statusString{
	if (self  = [super init])
		{
		_bumpstatus = [[NSMutableDictionary alloc]init];
		NSArray *array_status = [statusString componentsSeparatedByString:@","];
		NSInteger index = 1;
		for (NSString *status in array_status) {
			[_bumpstatus setObject:[NSString stringWithFormat:@"%ld",(long)(index ++)] forKey:status];
		}
	}
	return self;
}

@end
