#ifndef GPGateway_h
#define GPGateway_h

#import <Foundation/Foundation.h>
#import <GlobalPaymentsApi/GPGatewayResponse.h>

typedef void (^CompletionBlock)(NSData*, NSURLResponse*, NSError*);

@protocol GPURLSessionDataTaskProtocol <NSObject>
@property (nonatomic, copy) CompletionBlock nextCompletionHandler;
- (void)resume;
@end

@protocol GPURLSessionProtocol <NSObject>
- (id<GPURLSessionDataTaskProtocol>)dataTaskWithRequest:(NSMutableURLRequest*)request
                                      completionHandler:(void(^)(NSData*, NSURLResponse*, NSError*))responseBlock;
@end

@interface NSURLSessionDataTask (RequiredExtension) <GPURLSessionDataTaskProtocol>
@end

@interface NSURLSession (RequiredExtension) <GPURLSessionProtocol>
@end

/**
 Base gateway class to handle basic HTTP requests. This acts as an HTTP client for the underlying gateway service.
 */
@interface GPGateway : NSObject

/** Request headers */
@property (nonatomic, strong) NSMutableDictionary* headers;

/** Request timeout */
@property (nonatomic, assign) NSInteger timeout;

/** Base service URL */
@property (nonatomic, strong) NSString* serviceUrl;

/** Request content type */
@property (nonatomic, readwrite) NSString* contentType;

/** URL Session */
@property (nonatomic, strong) id<GPURLSessionProtocol> session;

/**
 Creates a new gateway instance with the defined content type.

 @param contentType The desired content type
 @return a new gateway instance
 */
- (id)initWithContentType:(NSString*)contentType;

/**
 Updates session instance on the gateway object.

 @param session The new session instance for use by the gateway
 @return an updated gateway
 */
- (id)withURLSession:(id<GPURLSessionProtocol>)session;

/**
 Sends an HTTP request to the underlying gateway service

 @param httpMethod Request HTTP method
 @param endpoint Request endpoint
 @param data Request data
 @param queryParams Query string parameters
 @param completionHandler Callback for request completion
 */
- (void)sendRequest:(NSString*)httpMethod endPoint:(NSString*)endpoint
               data:(NSString*)data
        queryParams:(NSDictionary*)queryParams
  completionHandler:(void(^)(GPGatewayResponse*, NSError*))completionHandler;

/**
 Constructs a query string from key/value pairs

 @param params The desired key/value pairs
 @return a raw query string
 */
+ (NSString*)buildQueryString:(NSDictionary*)params;

@end

#endif /* GPGateway_h */
