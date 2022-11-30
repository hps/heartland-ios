#import <Foundation/Foundation.h>
#import "HpsBaseTableServiceResponse.h"

@interface HpsTableServiceResponse : HpsBaseTableServiceResponse

@property (strong)NSString *expectedAction;
@property (strong)NSString *configName;

-(id)initWithResponseDictionary:(NSDictionary *)responseDictionary;

-(void)sendRequestwithEndPoint:(NSString *)endPoint withMultiPartForm:(NSDictionary *)formData withCompletion:(void(^)(HpsTableServiceResponse *, NSError*))responseBlock;

@end
