#import <Foundation/Foundation.h>

@interface HpsGatewayResponse : NSObject

@property (nonatomic, strong) NSString* rawResponse;
@property (nonatomic, strong) NSString* requestUrl;
@property (nonatomic, assign) NSInteger statusCode;

@end
