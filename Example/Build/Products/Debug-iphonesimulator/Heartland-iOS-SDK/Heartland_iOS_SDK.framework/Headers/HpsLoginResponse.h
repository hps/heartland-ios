#import "HpsTableServiceResponse.h"

@interface HpsLoginResponse : HpsTableServiceResponse

@property NSString *locationId ;
@property NSString * token;
@property NSString *sessionId;
@property NSString *tableStatus;

-(id)initWithResponseDictionary:(NSDictionary *)responseDictionary;

@end
