#import <Foundation/Foundation.h>

@interface HpsPayRollRequest : NSObject

@property (nonatomic,retain) NSString *endPoint;
@property (nonatomic,retain) NSString *requestBody;

-(id)initWithEndPoint:(NSString *)endPoint withRequestBody:(NSString *)requestBody;

@end
