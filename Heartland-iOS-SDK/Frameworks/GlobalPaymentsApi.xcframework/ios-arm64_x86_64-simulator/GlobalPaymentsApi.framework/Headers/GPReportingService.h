#ifndef GPReportingService_h
#define GPReportingService_h

#import <Foundation/Foundation.h>
#import <GlobalPaymentsApi/GPEnums.h>
#import <GlobalPaymentsApi/GPTransactionSummary.h>

@interface GPReportingService : NSObject

+ (void) findTransactions:(void(^)(NSArray<GPTransactionSummary*>*, NSError*)) completionHandler;
+ (void) findTransactions:(void(^)(NSArray<GPTransactionSummary*>*, NSError*)) completionHandler
           withConfigName:(NSString*) configName;

+ (void) findTransactions:(void(^)(NSArray<GPTransactionSummary*>*, NSError*)) completionHandler
             withCriteria:(NSDictionary*) criteria;
+ (void) findTransactions:(void(^)(NSArray<GPTransactionSummary*>*, NSError*)) completionHandler
             withCriteria:(NSDictionary*) criteria
           withConfigName:(NSString*) configName;

+ (void) findTransactions:(void(^)(GPTransactionSummary*, NSError*)) completionHandler
        withTransactionId:(NSString*) transactionId;
+ (void) findTransactions:(void(^)(GPTransactionSummary*, NSError*)) completionHandler
        withTransactionId:(NSString*) transactionId
           withConfigName:(NSString*) configName;

+ (void) transactionDetail:(NSString*) transactionId
         completionHandler:(void(^)(GPTransactionSummary*, NSError*)) completionHandler;
+ (void) transactionDetail:(NSString*) transactionId
         completionHandler:(void(^)(GPTransactionSummary*, NSError*)) completionHandler
            withConfigName:(NSString*) configName;

@end

#endif /* GPReportingService_h */
