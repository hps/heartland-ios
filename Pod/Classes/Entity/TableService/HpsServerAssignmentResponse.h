//
//  HpsServerAssignmentResponse.h
//  Pods
//
//  Created by anurag sharma on 12/04/18.
//
//

#import "HpsTableServiceResponse.h"

@interface HpsServerAssignmentResponse : HpsTableServiceResponse

@property NSMutableDictionary *assignments;
-(id)initWithResponseDictionary:(NSDictionary *)responseDictionary;
@end
