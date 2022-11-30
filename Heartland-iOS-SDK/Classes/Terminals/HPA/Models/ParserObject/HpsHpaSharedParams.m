#import "HpsHpaSharedParams.h"

NSOperationQueue *operationQueue ;

@implementation HpsHpaSharedParams

+(HpsHpaSharedParams*)getInstance
{
	static id instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[self alloc] init];
	});
	return instance;
}

-(id) init
{
	if (self = [super init])
		{
		self.params = [NSMutableDictionary new];
        self.paramsInArray = [NSMutableDictionary new];
        operationQueue = [[NSOperationQueue alloc] init];
		_transactionSummaryRecords = [NSMutableArray new];;
		_cardSummaryRecords = [NSMutableArray new];
		}
	return self;
}

-(void)addTranasactionSummaryRecords:(TransactionSummaryRecord *)Record
{
	[self.transactionSummaryRecords addObject:Record];
}

-(void)addCardSummaryRecords:(CardSummaryRecord *)Record
{
	[self.cardSummaryRecords addObject:Record];
}

-(void)setLastResponseData:(HpsLastResponse *)Response
{
    self.lastResponse = Response;
}

-(void)addParaMeter:(NSString*)tableName withValues:(NSDictionary *)values
{
	[operationQueue addOperationWithBlock: ^{
		NSMutableDictionary *addMore;
		if (!( addMore = [[HpsHpaSharedParams getInstance].params objectForKey:tableName?tableName:self.tableCategory])) {
			[[HpsHpaSharedParams getInstance].params setValue:values forKey:tableName?tableName:self.tableCategory];
		}
		else
			{

			[addMore addEntriesFromDictionary:values];
			[[HpsHpaSharedParams getInstance].params setValue:addMore forKey:tableName?tableName:self.tableCategory];

			}

		self.tableCategory = tableName ? tableName :self->_tableCategory;

	}];
}

-(void)addParamInArray:(NSString*)tableName withValues:(NSMutableArray *)data
{
    
    [[HpsHpaSharedParams getInstance].paramsInArray setValue:data forKey:tableName?tableName:self.tableCategory];
    
    
}

@end
