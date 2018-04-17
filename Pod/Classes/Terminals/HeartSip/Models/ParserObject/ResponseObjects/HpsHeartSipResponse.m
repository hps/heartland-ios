	//  Copyright (c) 2017 Heartland Payment Systems. All rights reserved.


#import "HpsHeartSipResponse.h"
#import "HpsHeartSipSharedParams.h"
@interface HpsHeartSipResponse()
{
}

@property (readwrite,retain) NSMutableDictionary *params;

@end
static int IsFieldEnable;

@implementation HpsHeartSipResponse
-(id)init{
	if(self = [super init])
		{
		IsFieldEnable = NO;
		[HpsHeartSipSharedParams getInstance].class_type = RESPONSE;

		}
	return self;
}

-(id)initWithXMLData:(NSData *)data withSetRecord:(BOOL)value
{
	IsFieldEnable = value;
	if (self = [super initWithXMLData:data]) {

	}
	return self;
}

-(void)setTransactionSummaryRecord:(TransactionSummaryRecord *)TransactionSummaryRecord{
	if (TransactionSummaryRecord) {
		[[HpsHeartSipSharedParams getInstance]addTranasactionSummaryRecords:TransactionSummaryRecord];
	}
}

-(void)setCardSummaryRecord:(CardSummaryRecord *)CardSummaryRecord{
	if (CardSummaryRecord) {
		[[HpsHeartSipSharedParams getInstance]addCardSummaryRecords:CardSummaryRecord];
	}
}

-(void)setRecord:(Record *)Record
{
	if (Record.TableCategory) {
			//		NSLog(@"TableCategory = %@",Record.TableCategory);
			//		NSLog(@"Fields = %@", Record.Fields);
		[[HpsHeartSipSharedParams getInstance]addParaMeter:Record.TableCategory withValues:Record.Fields];
	}else {
			//NSLog(@"Extra Fields = %@", Record.Fields);
		[[HpsHeartSipSharedParams getInstance]addParaMeter:Record.TableCategory withValues:Record.Fields];
	}
}

@end
