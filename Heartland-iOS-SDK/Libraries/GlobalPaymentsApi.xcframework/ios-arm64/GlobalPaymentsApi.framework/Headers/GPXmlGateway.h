#ifndef GPXmlGateway_h
#define GPXmlGateway_h

#import <Foundation/Foundation.h>
#import <GlobalPaymentsApi/GPGateway.h>

@interface GPXmlGateway : GPGateway

@property (nonatomic, strong) NSString* startElement;

- (NSString*) serializeRequest:(NSDictionary*)data;

@end

#endif /* GPXmlGateway_h */
