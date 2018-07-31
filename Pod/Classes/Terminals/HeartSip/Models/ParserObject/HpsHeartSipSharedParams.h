#import <Foundation/Foundation.h>
#import "TransactionSummaryRecord.h"
#import "CardSummaryRecord.h"

typedef NS_ENUM(NSInteger,CLASS_TYPE)
{
	REQUEST,
	RESPONSE
};

@interface HpsHeartSipSharedParams : NSObject

@property NSMutableDictionary *params;
@property NSMutableArray *transactionSummaryRecords;
@property NSMutableArray *cardSummaryRecords;
@property CLASS_TYPE class_type;
@property NSString *tableCategory;

+(HpsHeartSipSharedParams*)getInstance;
-(void)addParaMeter:(NSString*)tableName withValues:(NSDictionary *)values;
-(void)addCardSummaryRecords:(CardSummaryRecord *)Record;
-(void)addTranasactionSummaryRecords:(TransactionSummaryRecord *)Record;

@end
