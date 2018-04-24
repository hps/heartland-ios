//
//  HpsServerListResponse.h
//  Pods
//
//  Created by anurag sharma on 12/04/18.
//
//
#import "HpsTableServiceResponse.h"

@interface HpsServerListResponse : HpsTableServiceResponse
@property NSArray *servers;
-(id)initWithResponseDictionary:(NSDictionary *)responseDictionary;

@end
