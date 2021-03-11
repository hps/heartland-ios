#ifndef GPPorticoGateway_h
#define GPPorticoGateway_h

#import <Foundation/Foundation.h>
#import <GlobalPaymentsApi/GPServicesConfig.h>
#import <GlobalPaymentsApi/GPXmlGateway.h>
#import <GlobalPaymentsApi/GPTransaction.h>
#import <GlobalPaymentsApi/GPAuthorizationBuilder.h>
#import <GlobalPaymentsApi/GPManagementBuilder.h>
#import <GlobalPaymentsApi/GPTransactionSummary.h>

@interface GPPorticoGateway : GPXmlGateway

@property (nonatomic, strong) GPServicesConfig* config;

- (id)initWithConfig:(GPServicesConfig*)config;
- (void)processAuthorization:(GPAuthorizationBuilder*)builder
   completionHandler:(void(^)(GPTransaction*, NSError*))completionHandler;
- (void)manageTransaction:(GPManagementBuilder*)builder
  completionHandler:(void(^)(GPTransaction*, NSError*))completionHandler;
- (void)processReport:(NSDictionary*)request
          requestType:(NSString*)requestType
    completionHandler:(void(^)(NSArray<GPTransactionSummary*>*, NSError*))completionHandler;

@end


#endif /* GPPorticoGateway_h */
