//
//  HpsLoginResponse.h
//  Pods
//
//  Created by anurag sharma on 06/04/18.
//
//

#import "HpsTableServiceResponse.h"

@interface HpsLoginResponse : HpsTableServiceResponse
	/// <summary>
	/// Location Id of the restauant
	/// </summary>
@property NSString *locationId ;
	/// <summary>
	/// security token for subsequent calls
	/// </summary>
@property NSString * token;
	/// <summary>
	/// Session Id (should always be 10101)
	/// </summary>
@property NSString *sessionId;
	/// <summary>
	/// status string as returned from the table service API
	/// </summary>
@property NSString *tableStatus;

-(id)initWithResponseDictionary:(NSDictionary *)responseDictionary;

@end
