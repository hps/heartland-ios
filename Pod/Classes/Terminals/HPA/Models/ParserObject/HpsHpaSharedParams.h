#import <Foundation/Foundation.h>
#import "TransactionSummaryRecord.h"
#import "CardSummaryRecord.h"

typedef NS_ENUM(NSInteger,CLASS_TYPE)
{
	REQUEST,
	RESPONSE
};

@interface HpsHpaSharedParams : NSObject

@property NSMutableDictionary *params;
@property NSMutableArray *transactionSummaryRecords;
@property NSMutableArray *cardSummaryRecords;
@property CLASS_TYPE class_type;
@property NSString *tableCategory;

+(HpsHpaSharedParams*)getInstance;
-(void)addParaMeter:(NSString*)tableName withValues:(NSDictionary *)values;
-(void)addCardSummaryRecords:(CardSummaryRecord *)Record;
-(void)addTranasactionSummaryRecords:(TransactionSummaryRecord *)Record;

@end
