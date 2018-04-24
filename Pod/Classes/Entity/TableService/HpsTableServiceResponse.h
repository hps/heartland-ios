//
//  HpsTableServiceResponse.h
//  Pods
//
//  Created by anurag sharma on 04/04/18.
//
//

#import <Foundation/Foundation.h>
#import "HpsBaseTableServiceResponse.h"

@interface HpsTableServiceResponse : HpsBaseTableServiceResponse
@property (strong)NSString *expectedAction;
@property (strong)NSString *configName;

-(id)initWithResponseDictionary:(NSDictionary *)responseDictionary;

-(void)sendRequestwithEndPoint:(NSString *)endPoint withMultiPartForm:(NSDictionary *)formData withCompletion:(void(^)(HpsTableServiceResponse *, NSError*))responseBlock;
@end
