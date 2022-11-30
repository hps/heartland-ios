#ifndef GPGatewayResponse_h
#define GPGatewayResponse_h

#import <Foundation/Foundation.h>

@interface GPGatewayResponse : NSObject

@property (nonatomic, strong) NSString* rawResponse;
@property (nonatomic, strong) NSString* requestUrl;
@property (nonatomic, assign) NSInteger statusCode;

@end

#endif /* GPGatewayResponse_h */
