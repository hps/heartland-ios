#import <Foundation/Foundation.h>
#import "HpsGateway.h"
#import "HpsJsonDoc.h"
#import "HpsGatewayResponse.h"

@interface HpsRestGateway : NSObject

@property (nonatomic, strong) NSMutableDictionary* headers;
@property (nonatomic, assign) NSInteger timeOut;
@property (nonatomic, strong) NSString* serviceUrl;

-(void)doTransaction:(NSString*)httpMethod endPoint:(NSString*)endPoint data:(NSString*)data andQueryParams:(NSDictionary*)params handler:(void (^)(NSString* response, NSError* error))responseBlock;
-(NSString*)handleResponse:(HpsGatewayResponse*)response;

@end
