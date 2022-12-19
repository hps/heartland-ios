#import "HpsLoginResponse.h"

@implementation HpsLoginResponse

-(id)initWithResponseDictionary:(NSDictionary *)responseDictionary{
	if (self =  [super initWithResponseDictionary:responseDictionary]) {
		_locationId = responseDictionary[@"data"][@"row"][@"locID"];
		_sessionId = responseDictionary[@"data"][@"row"][@"sessionID"];
		_token = responseDictionary[@"data"][@"row"][@"token"];
		_tableStatus = responseDictionary[@"data"][@"row"][@"tableStatus"];
	}
	self.expectedAction = @"login";

	return self;
}

@end
