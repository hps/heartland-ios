#import "HpsPayRollRequest.h"

@implementation HpsPayRollRequest

-(id)init {

	self = [super init];

	_requestBody = @"";
	_endPoint = @"";

	return self;
}

-(id)initWithEndPoint:(NSString *)endPoint withRequestBody:(NSString *)requestBody
{
	if (self = [super init]) {
		_requestBody = requestBody;
		_endPoint = endPoint;
	}
	return self;
}

@end
