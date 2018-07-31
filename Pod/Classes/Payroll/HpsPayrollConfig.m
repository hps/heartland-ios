#import "HpsPayrollConfig.h"

@implementation HpsPayrollConfig

-(id)initWithUserName:(NSString *)userName withPassword:(NSString *)password withApiKey:(NSString *)apiKey withServiceUrl:(NSString *)serviceUrl withTimeout:(NSInteger)timeout
{
	if (self = [super init]) {
		_userName = userName;
		_password = password;
		_apiKey = apiKey;
		_serviceUrl = serviceUrl;
		_timeOut = timeout;
	}

	return self;
}

@end
