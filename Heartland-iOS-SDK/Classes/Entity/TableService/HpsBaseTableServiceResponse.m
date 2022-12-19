#import "HpsBaseTableServiceResponse.h"

@implementation HpsBaseTableServiceResponse

-(id)initWithResponseDictionary:(NSDictionary *)response;
{
	if (self = [super init]) {
		if (response!=nil) {

			_responseCode = [self normalizeResponse:response [@"code"]];
			_responseText = response[@"codeMsg"];
			_Class = response [@"class"];
			_action = response[@"action"];
			if (![_responseCode isEqualToString:@"00"]) {
				@throw [NSException exceptionWithName:@"MessageException" reason:_responseText userInfo:nil];
			}
			if (response[@"data"]){
				if (response[@"data"][@"row"]){
					[self mapResponse];
				}
			}

		}
	}
	return self;
}

-(NSString *)normalizeResponse:(NSString *)responseCode{
	NSArray *acceptedCodes = @[@"01"];
	if ([acceptedCodes containsObject:responseCode]) {
		return @"00";
}
	return responseCode;
}

-(void)mapResponse
{
		[NSException raise:NSInternalInconsistencyException format:@"Method Not Implememnted %@ in %@",NSStringFromSelector(_cmd),NSStringFromClass([self class])];
}

@end
