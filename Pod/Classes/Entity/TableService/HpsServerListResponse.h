#import "HpsTableServiceResponse.h"

@interface HpsServerListResponse : HpsTableServiceResponse

@property NSArray *servers;

-(id)initWithResponseDictionary:(NSDictionary *)responseDictionary;

@end
