#ifndef GPPorticoResponseParser_h
#define GPPorticoResponseParser_h

#import <Foundation/Foundation.h>
#import <GlobalPaymentsApi/GlobalPaymentsApi.h>

@interface GPPorticoResponseParser : NSObject<NSXMLParserDelegate>

@property (nonatomic, retain) NSXMLParser* parser;
@property (nonatomic, retain) NSMutableString* currentElement;
@property (nonatomic, retain) NSString* gatewayResponseCode;
@property (nonatomic, retain) NSString* gatewayResponseMessage;
@property (nonatomic, retain) GPTransaction* transaction;
@property (nonatomic, retain) GPTransactionSummary* singleReport;
@property (nonatomic, retain) NSArray* listReport;
@property (nonatomic, retain) NSString* requestType;

- (id) initWithString:(NSString*) xml;
- (BOOL) parse:(NSString*) requestType;

@end

#endif /* GPPorticoResponseParser_h */
