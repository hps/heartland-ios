#ifndef GPBatchService_h
#define GPBatchService_h

#import <Foundation/Foundation.h>
#import <GlobalPaymentsApi/GPEnums.h>
#import <GlobalPaymentsApi/GPBatchSummary.h>
#import <GlobalPaymentsApi/GPTransaction.h>

@interface GPBatchService : NSObject

+ (void) closeBatch:(void(^)(GPTransaction*, NSError*))completionHandler;

@end

#endif /* GPBatchService_h */
