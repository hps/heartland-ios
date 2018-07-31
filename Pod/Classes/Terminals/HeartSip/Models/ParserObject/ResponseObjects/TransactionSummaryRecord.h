#import <Foundation/Foundation.h>

@interface TransactionSummaryRecord : NSObject

@property (readonly,retain) NSString *TransactionSummary;
@property (readonly,retain) NSString *BatchTxnCnt;
@property (readonly,retain) NSString *TransactionType;
@property (readonly,retain) NSString *TotalAmount;

@end
