
#import "CardSummary.h"

#define SHARED_PARAMS [HpsHpaSharedParams getInstance]
@implementation CardSummary

-(id)init {
    
    self = [super init];
    
    return self;
}

-(id)initWithPayload:(id <HpaResposeInterface>)response {
    
    if (!self) {  self = [super init]; }
    
    NSString *Category = SHARED_PARAMS.tableCategory;    
    NSMutableArray *summaryFields = [SHARED_PARAMS.paramsInArray objectForKey:Category];
    
    for ( int i=0 ; i< summaryFields.count;i++){
        
        Field *field = [summaryFields objectAtIndex:i];
        if ([field.Key isEqualToString:@"CardType"]){
        self.CardType = field.Value;
        }else if ([field.Key isEqualToString:@"TransType"]) {
            
            Field *tempFields = [summaryFields objectAtIndex:++i];
            NSString *count = tempFields.Value;
            tempFields = [summaryFields objectAtIndex:++i];
            NSString *amount = tempFields.Value;
            if([field.Value isEqualToString:@"CREDIT"])
            {
                self.creditCount = count;
                self.creditAmount = amount;
            }
            else if([field.Value isEqualToString:@"DEBIT"])
            {
                self.debitCount = count;
                self.debitAmount = amount;
            }
            else if([field.Value isEqualToString: @"SALE"])
            {
                self.saleCount = count;
                self.saleAmount = amount;
            }
            else if([field.Value isEqualToString:@"REFUND"])
            {
                self.refundCount = count;
                self.refundAmount = amount;
            }
            else if([field.Value isEqualToString:@"TOTAL"])
            {
                self.totalAmount = count;
                self.totalAmount = amount;
            }
        }
    }
    
    return self;
}

@end
