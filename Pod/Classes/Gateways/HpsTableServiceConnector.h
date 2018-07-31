#import <Foundation/Foundation.h>
#import "HpsGateway.h"
#import "HpsBumpStatusCollection.h"

@interface HpsTableServiceConnector :HpsGateway <NSURLSessionDataDelegate,NSURLSessionTaskDelegate>
@property (strong)NSString *locationId;
@property (strong)NSString *securityToken;
@property (strong)NSString *sessionId;

@property HpsBumpStatusCollection *bupStatusCollection;
-(void) callWithEndPoint:(NSString *) endpoint withMultipartForm:(NSDictionary *) content withCompletion:(void(^)(NSDictionary *, NSError*))responseBlock ;
-(Boolean) Configured ;

@end
