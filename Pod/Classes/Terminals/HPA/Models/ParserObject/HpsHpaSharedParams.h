#import <Foundation/Foundation.h>
#import "TransactionSummaryRecord.h"
#import "CardSummaryRecord.h"
#import "HpsLastResponse.h"

typedef NS_ENUM(NSInteger,CLASS_TYPE)
{
	REQUEST,
	RESPONSE
};

@interface HpsHpaSharedParams : NSObject

@property NSMutableDictionary *params;
@property NSMutableDictionary *paramsInArray;
@property NSMutableArray *transactionSummaryRecords;
@property NSMutableArray *cardSummaryRecords;
@property CLASS_TYPE class_type;
@property NSString *tableCategory;
@property(strong,atomic) HpsLastResponse *lastResponse;

+(HpsHpaSharedParams*)getInstance;
-(void)addParaMeter:(NSString*)tableName withValues:(NSDictionary *)values;
-(void)addParamInArray:(NSString*)tableName withValues:(NSMutableArray *)data;
-(void)addCardSummaryRecords:(CardSummaryRecord *)Record;
-(void)addTranasactionSummaryRecords:(TransactionSummaryRecord *)Record;
-(void)setLastResponseData:(HpsLastResponse *)Response;

@end
