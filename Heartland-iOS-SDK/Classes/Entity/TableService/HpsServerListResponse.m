#import "HpsServerListResponse.h"

@implementation HpsServerListResponse

-(id)initWithResponseDictionary:(NSDictionary *)responseDictionary{
	if (self = [super initWithResponseDictionary:responseDictionary]) {
		_servers = [[NSArray alloc]init];
		if (responseDictionary[@"data"][@"row"][@"serverList"]) {
			NSString *servers = responseDictionary[@"data"][@"row"][@"serverList"];
			_servers = [servers componentsSeparatedByString:@","];
		}

	}
	self.expectedAction= @"getServerList";
	return self;
}

@end
