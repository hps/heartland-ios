#import <Foundation/Foundation.h>
#import "HpsGatewayResponse.h"

@interface HpsGateway : NSObject

@property (nonatomic, strong) NSMutableDictionary* headers;
@property (nonatomic, assign) NSInteger timeOut;
@property (nonatomic, strong) NSString* serviceUrl;

-(id)initWithGateway:(NSString*)contentType;
-(void)sendRequest:(NSString*)httpMethod endPoint:(NSString*)endpoint data:(NSString*)data queryParams:(NSDictionary*)params handler:(void(^)(HpsGatewayResponse *gatewayObject, NSError* error))responseBlock;
-(void)sendRequestWithEndPoint:(NSString *)endPoint withMultiPart:(NSDictionary *)content handler:(void(^)(HpsGatewayResponse *gatewayObject, NSError* error))responseBlock;

@end
