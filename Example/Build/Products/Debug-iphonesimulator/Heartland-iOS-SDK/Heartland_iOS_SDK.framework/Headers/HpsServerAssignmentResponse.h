#import "HpsTableServiceResponse.h"

@interface HpsServerAssignmentResponse : HpsTableServiceResponse

@property NSMutableDictionary *assignments;

-(id)initWithResponseDictionary:(NSDictionary *)responseDictionary;

@end
