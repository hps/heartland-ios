#ifndef GPBatchSummary_h
#define GPBatchSummary_h

#import <Foundation/Foundation.h>
#import <GlobalPaymentsApi/GPEnums.h>

@interface GPBatchSummary : NSObject

@property (nonatomic, strong) NSString* batchId;
@property (nonatomic, strong) NSString* sequenceNumber;
@property (nonatomic, strong) NSString* totalAmount;
@property (nonatomic, strong) NSString* transactionCount;

@end

#endif /* GPBatchSummary_h */
