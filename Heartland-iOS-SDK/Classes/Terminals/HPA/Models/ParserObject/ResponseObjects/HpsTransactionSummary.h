#import <Foundation/Foundation.h>
#import "HpsHpaResponse.h"

@interface HpsTransactionSummary : NSObject

@property (nonatomic,strong) NSString *TableCategory;
@property (nonatomic,strong) NSString *TransactionId;
@property (nonatomic,strong) NSString *TransactionTime;
@property (nonatomic,strong) NSString *TransactionType;
@property (nonatomic,strong) NSString *MaskedPAN;
@property (nonatomic,strong) NSString *CardType;
@property (nonatomic,strong) NSString *CardAcquisition;
@property (nonatomic,strong) NSString *ApprovalCode;
@property (nonatomic,strong) NSString *ResponseCode;
@property (nonatomic,strong) NSString *ResponseText;
@property (nonatomic,strong) NSString *HostTimeOut;
@property (nonatomic,strong) NSString *TaxAmount;
@property (nonatomic,strong) NSString *TipAmount;
@property (nonatomic,strong) NSString *RequestAmount;
@property (nonatomic,strong) NSString *AuthorizedAmount;
@property (nonatomic,strong) NSString *BalanceDueAmount;
@property (nonatomic,strong) NSString *ReferenceNumber;
@property (nonatomic,strong) NSString *TransactionStatus;
@property (nonatomic,strong) NSString *CashbackAmount;
@property (nonatomic,strong) NSString *SettleAmount;

-(id)initWithPayload:(id <HpaResposeInterface>)response;

@end


