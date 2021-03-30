#import <Foundation/Foundation.h>

@interface CardSummaryRecord : NSObject

@property (readonly,retain) NSString *CardType;
@property (readonly,retain) NSString *TransType;
@property (readonly,retain) NSString *NumberTransactions;
@property (readonly,retain) NSString *TotalAmount;

@end
