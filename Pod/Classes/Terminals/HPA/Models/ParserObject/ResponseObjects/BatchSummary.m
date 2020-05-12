
#import "BatchSummary.h"

#define SHARED_PARAMS [HpsHpaSharedParams getInstance]

@implementation BatchSummary

-(id)init {
    
    self = [super init];
    
    return self;
}

-(id)initWithPayload:(id <HpaResposeInterface>)response {
    
    if (!self) {  self = [super init]; }
    
    NSString *Category = SHARED_PARAMS.tableCategory;    
    NSMutableDictionary *batchdetails = [SHARED_PARAMS.params objectForKey:Category];
    self.merchantName = [batchdetails valueForKey:@"MerchantName"];
    self. siteId = [batchdetails valueForKey:@"SiteId"];
    self.deviceId = [batchdetails valueForKey:@"DeviceId"];
    self.batchId = [batchdetails valueForKey:@"BatchId"];
    self.batchSequenceNumber = [batchdetails valueForKey:@"BatchSeqNbr"];
    self.batchStatus = [batchdetails valueForKey:@"BatchStatus"];
    self.openTime = [batchdetails valueForKey:@"OpenUtcDT"];
    self.transactioId = [batchdetails valueForKey:@"OpenTxnId"];
    self.transactionCount = [batchdetails valueForKey:@"BatchTxnCnt"];
    self.batchTransactionAmount = [batchdetails valueForKey:@"BatchTxnAmt"];    
    if([[batchdetails allKeys] containsObject:@"CreditCnt"]) {
    self.creditCount = [batchdetails valueForKey:@"CreditCnt"];
    }
    if([[batchdetails allKeys] containsObject:@"CreditAmt"]) {
        self.creditAmount = [batchdetails valueForKey:@"CreditAmt"];
    }
    if([[batchdetails allKeys] containsObject:@"DebitCnt"]) {
        self.debitCount = [batchdetails valueForKey:@"DebitCnt"];
    }
    if([[batchdetails allKeys] containsObject:@"DebitAmt"]) {
        self.debitAmount = [batchdetails valueForKey:@"DebitAmt"];
    }
    if([[batchdetails allKeys] containsObject:@"SaleCnt"]) {
        self.saleCount = [batchdetails valueForKey:@"SaleCnt"];
    }
    if([[batchdetails allKeys] containsObject:@"SaleAmt"]) {
        self.saleAmount = [batchdetails valueForKey:@"SaleAmt"];
    }
    if([[batchdetails allKeys] containsObject:@"ReturnCnt"]) {
        self.returnCount = [batchdetails valueForKey:@"ReturnCnt"];
    }
    if([[batchdetails allKeys] containsObject:@"ReturnAmt"]) {
        self.returnAmount = [batchdetails valueForKey:@"ReturnAmt"];
    }
    return self;
}
@end
