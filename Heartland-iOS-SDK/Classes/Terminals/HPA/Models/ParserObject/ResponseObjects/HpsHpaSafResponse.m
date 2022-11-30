#import "HpsHpaSafResponse.h"
#import "NSObject+ObjectMap.h"
#import "HpsHpaParser.h"
#import "SummaryResponse.h"
#import "HpsTransactionSummary.h"
#import "HpaEnums.h"

#define SHARED_PARAMS [HpsHpaSharedParams getInstance]

@interface HpsHpaSafResponse()

@property (nonatomic,strong) NSString *requestIDRecord;
@property (nonatomic,strong) HpsTransactionSummary *lastTransactionSummary;

@end

@implementation HpsHpaSafResponse
@synthesize responseCode;

-(id)initWithHpaSafResponse:(NSData *)data
{
    self = [super init];
        self.approved = [NSMutableDictionary new];
        self.pending = [NSMutableDictionary new];
        self.declined = [NSMutableDictionary new];
        NSString *xmlString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *arr = [xmlString componentsSeparatedByString:@"</SIP>"];
      
        for (NSString *response in arr) {
            id <HpaResposeInterface> responeN = [HpsHpaParser parseResponseWithXmlString:[NSString stringWithFormat:@"%@</SIP>",response]];
            [self mapResponse:responeN];
        } 
    return self;
}

-(void)mapResponse:(id <HpaResposeInterface>)response {
    
    if(response.Result != nil)
    {
        self.deviceId = response.DeviceId;
        self.transactionId = response.TransactionId;
        self.responseCode = response.Result;
        self.responseText = response.ResultText;
    
    NSString *Category = SHARED_PARAMS.tableCategory;
    
    if (Category != nil) {
        NSMutableDictionary *fieldValues = [SHARED_PARAMS.params objectForKey:Category];
       
    if([Category containsString:@"SUMMARY"])
    {
    SummaryResponse *SummaryResponseObject = [[SummaryResponse alloc]init];
        SummaryResponseObject.totalAmount = [fieldValues objectForKey:@"Amount"];
        SummaryResponseObject.count = [fieldValues objectForKey:@"Count"];
        SummaryResponseObject.summaryType = Category;
        
        if ([Category containsString:@"APPROVED"]) {
            if (self.approved != nil) {
                [self.approved setObject:SummaryResponseObject forKey:[self mapSummaryType:Category]];
            }
        }
        else if ([Category containsString:@"DECLINED"]) {
            if (self.declined != nil) {
                [self.declined setObject:SummaryResponseObject forKey:[self mapSummaryType:Category]];
            }
        }
        else if ([Category containsString:@"PENDING"]) {
            if (self.pending != nil) {
                [self.pending setObject:SummaryResponseObject forKey:[self mapSummaryType:Category]];
            }
        }
        SummaryResponseObject = nil;
    }
    
    else if([Category containsString:@"RECORD"])
    {
        HpsTransactionSummary *transactionSummaryObject = [[HpsTransactionSummary alloc]init];
        
        if (_requestIDRecord == response.RequestId) {            
            transactionSummaryObject = _lastTransactionSummary;
        }
        if([[fieldValues allKeys] containsObject:@"TransactionId"]) {
            transactionSummaryObject.TransactionId = [fieldValues valueForKey:@"TransactionId"];
        }
        if([[fieldValues allKeys] containsObject:@"TransactionTime"]) {
            transactionSummaryObject.TransactionTime = [fieldValues valueForKey:@"TransactionTime"];
        }
        if([[fieldValues allKeys] containsObject:@"TransactionType"]) {
            transactionSummaryObject.TransactionType = [fieldValues valueForKey:@"TransactionType"];
        }
        if([[fieldValues allKeys] containsObject:@"MaskedPAN"]) {
            transactionSummaryObject.MaskedPAN = [fieldValues valueForKey:@"MaskedPAN"];
        }
        if([[fieldValues allKeys] containsObject:@"CardType"]) {
            transactionSummaryObject.CardType = [fieldValues valueForKey:@"CardType"];
        }
        if([[fieldValues allKeys] containsObject:@"CardAcquisition"]) {
            transactionSummaryObject.CardAcquisition = [fieldValues valueForKey:@"CardAcquisition"];
        }
        if([[fieldValues allKeys] containsObject:@"ApprovalCode"]) {
            transactionSummaryObject.ApprovalCode = [fieldValues valueForKey:@"ApprovalCode"];
        }
        if([[fieldValues allKeys] containsObject:@"ResponseCode"]) {
            transactionSummaryObject.ResponseCode = [fieldValues valueForKey:@"ResponseCode"];
        }
        if([[fieldValues allKeys] containsObject:@"ResponseText"]) {
            transactionSummaryObject.ResponseText = [fieldValues valueForKey:@"ResponseText"];
        }
        if([[fieldValues allKeys] containsObject:@"HostTimeOut"]) {
            transactionSummaryObject.HostTimeOut = [fieldValues valueForKey:@"HostTimeOut"];
        }
        if([[fieldValues allKeys] containsObject:@"TaxAmount"]) {
            transactionSummaryObject.TaxAmount = [fieldValues valueForKey:@"TaxAmount"];
        }
        if([[fieldValues allKeys] containsObject:@"TipAmount"]) {
            transactionSummaryObject.TipAmount = [fieldValues valueForKey:@"TipAmount"];
        }
        if([[fieldValues allKeys] containsObject:@"RequestAmount"]) {
            transactionSummaryObject.RequestAmount = [fieldValues valueForKey:@"RequestAmount"];
        }
        if([[fieldValues allKeys] containsObject:@"Authorized Amount"]) {
            transactionSummaryObject.AuthorizedAmount = [fieldValues valueForKey:@"Authorized Amount"];
        }
        if([[fieldValues allKeys] containsObject:@"Balance Due Amount"]) {
            transactionSummaryObject.BalanceDueAmount = [fieldValues valueForKey:@"Balance Due Amount"];
        }
        
        
        if ([Category hasPrefix:@"APPROVED"] && _requestIDRecord != response.RequestId ) {
            SummaryResponse *summary = [self.approved valueForKey:@"Approved"];
            [summary.Records addObject:transactionSummaryObject];
            
        }
        else if ([Category hasPrefix:@"PENDING"]) {
            SummaryResponse *summary = [self.approved valueForKey:@"Pending"];
            [summary.Records addObject:transactionSummaryObject];
        }
        else if ([Category hasPrefix:@"DECLINED"]) {
            SummaryResponse *summary = [self.approved valueForKey:@"Declined"];
            [summary.Records addObject:transactionSummaryObject];
        }
          
        _lastTransactionSummary = transactionSummaryObject;
        _requestIDRecord = response.RequestId;
        transactionSummaryObject = nil;
    }
}
    }

}

-(NSString *)mapSummaryType:(NSString *)Category
{
    NSString *tempCategory = Category;
    
    if ([Category isEqualToString:HPA_SUMMARY_TYPE_toString[APPROVED]]) {
        tempCategory =  @"Approved";
    }
    else if ([Category isEqualToString:HPA_SUMMARY_TYPE_toString[PENDING]]) {
        tempCategory = @"Pending";
    }
    else if ([Category isEqualToString:HPA_SUMMARY_TYPE_toString[DECLINED]]) {
        tempCategory = @"Declined";
    }
    else if ([Category isEqualToString:HPA_SUMMARY_TYPE_toString[VOID_APPROVED]]) {
        tempCategory = @"VoidApproved";
    }
    else if ([Category isEqualToString:HPA_SUMMARY_TYPE_toString[VOID_PENDING]]) {
        tempCategory = @"VoidPending";
    }
    else if ([Category isEqualToString:HPA_SUMMARY_TYPE_toString[VOID_DECLINED]]) {
        tempCategory = @"VoidDeclined";
    }
    else if ([Category isEqualToString:HPA_SUMMARY_TYPE_toString[OFFLINE_APPROVED]]) {
        tempCategory = @"OfflineApproved";
    }else if ([Category isEqualToString:HPA_SUMMARY_TYPE_toString[PARTIALLY_APPROVED]]) {
        tempCategory = @"PartiallyApproved";
    }
    
    return tempCategory;
}

@end
