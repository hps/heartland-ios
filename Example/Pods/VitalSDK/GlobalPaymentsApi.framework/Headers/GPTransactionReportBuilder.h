#ifndef GPTransactionReportBuilder_h
#define GPTransactionReportBuilder_h

#import <Foundation/Foundation.h>
#import <GlobalPaymentsApi/GPEnums.h>

@class GPTransactionSummary;

@interface GPTransactionReportBuilder : NSObject

- (void) execute:(void(^)(GPTransactionSummary*, NSError*))completionHandler;
- (void) execute:(void(^)(GPTransactionSummary*, NSError*))completionHandler withConfigName:(NSString*) name;

@end

#endif /* GPTransactionReportBuilder_h */
