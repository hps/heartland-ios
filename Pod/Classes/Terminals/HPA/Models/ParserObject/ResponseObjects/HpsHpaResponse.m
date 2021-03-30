#import "HpsHpaResponse.h"
#import "HpsHpaSharedParams.h"

@interface HpsHpaResponse()

@property (readwrite,retain) NSMutableDictionary *params;

@end

static int IsFieldEnable;

@implementation HpsHpaResponse

-(id)init{
	if(self = [super init])
		{
		IsFieldEnable = NO;
		[HpsHpaSharedParams getInstance].class_type = RESPONSE;

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
		[[HpsHpaSharedParams getInstance]addTranasactionSummaryRecords:TransactionSummaryRecord];
	}
}

-(void)setCardSummaryRecord:(CardSummaryRecord *)CardSummaryRecord{
	if (CardSummaryRecord) {
		[[HpsHpaSharedParams getInstance]addCardSummaryRecords:CardSummaryRecord];
	}
}

-(void)setLastResponse:(HpsLastResponse *)LastResponse{
    if (LastResponse) {
        [[HpsHpaSharedParams getInstance]setLastResponseData:LastResponse];
    }
}

-(void)setRecord:(Record *)Record
{
	if (Record.TableCategory) {
			//		NSLog(@"TableCategory = %@",Record.TableCategory);
			//		NSLog(@"Fields = %@", Record.Fields);
		[[HpsHpaSharedParams getInstance]addParaMeter:Record.TableCategory withValues:Record.Fields];
        [[HpsHpaSharedParams getInstance]addParamInArray:Record.TableCategory withValues:Record.FieldsArray];
	}else {
			//NSLog(@"Extra Fields = %@", Record.Fields);
		[[HpsHpaSharedParams getInstance]addParaMeter:Record.TableCategory withValues:Record.Fields];
        [[HpsHpaSharedParams getInstance]addParamInArray:Record.TableCategory withValues:Record.FieldsArray];
	}
}

@end
