#import <Foundation/Foundation.h>
#import "HpsTerminalResponse.h"
#import "NSObject+ObjectMap.h"
#import "HpsHeartSipSharedParams.h"

@interface HpsHeartSipRequest : NSObject

@property (nonatomic,retain)NSString *Version;
@property (nonatomic,retain)NSString *ECRId;
@property (nonatomic,retain)NSString *SIPId;
@property (nonatomic,retain)NSString *Response;
@property (nonatomic,retain)NSString *MultipleMessage;
@property (nonatomic,retain)NSString *Result;
@property (nonatomic,retain)NSString *ResultText;
	//Credit Sale Req
@property (nonatomic,retain) NSString *Request;
@property (nonatomic,retain) NSString *CardGroup;
@property (nonatomic,retain) NSString *ConfirmAmount;
@property (nonatomic,retain) NSString *InvoiceNbr;
@property (nonatomic,retain) NSString *BaseAmount;
@property (nonatomic,retain) NSString *TaxAmount;
@property (nonatomic,retain) NSString *TotalAmount;
@property (nonatomic,retain) NSString *ServerLabel;
@property (nonatomic, readwrite) int RequestId;
	//Void
@property (nonatomic,retain) NSString *TransactionId;
	//Tip
@property (nonatomic,retain) NSString *TipAmount;

	//Credit

-(id)initWithCreditSaleRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withCardGroup:(NSString *)cardGroup withConfirmAmount:(NSString *)confirmAmount withInvoiceNbr:(NSString*)invoiceNbr withBaseAmount:(NSString *)baseAmount withTaxAmount:(NSString *)taxAmount withTotalAmount:(NSString *)totalAmount withServerLabel:serverLabel;

-(id)initWithCreditRefundRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withCardGroup:(NSString *)cardGroup withConfirmAmount:(NSString *)confirmAmount withInvoiceNbr:(NSString*)invoiceNbr withTotalAmount:(NSString *)totalAmount;

-(id)initWithCreditAuthRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withConfirmAmount:(NSString *)confirmAmount withInvoiceNbr:(NSString*)invoiceNbr withTotalAmount:(NSString *)totalAmount;

-(id) initWithCreditAuthCompleteWithVersion:(NSString *)version withEcrId:(NSString *)ecrID withRequest:(NSString *)request withTransactionId:(NSString *)transactionId withConfirmAmount:(NSString *)confirmAmount withTotalAmount:(NSString *)totalAmount withTipAmount:(NSString *)tipAmount;

-(id) initWithVoidTransacationRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withTransactionID:(NSString *)transactionID;

-(id) initWithCreditTipAdjustwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withTransactionID:(NSString *)transactionID withTipAmount:(NSString *)tipAmount;


	//Debit

-(id)initWithDebitSaleRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withCardGroup:(NSString *)cardGroup withConfirmAmount:(NSString *)confirmAmount withInvoiceNbr:(NSString*)invoiceNbr withBaseAmount:(NSString *)baseAmount withTaxAmount:(NSString *)taxAmount withTotalAmount:(NSString *)totalAmount withServerLabel:serverLabel;

-(id)initWithDebitRefundRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withCardGroup:(NSString *)cardGroup withConfirmAmount:(NSString *)confirmAmount withInvoiceNbr:(NSString*)invoiceNbr withTotalAmount:(NSString *)totalAmount;

	//Gift
-(id)initWithAddValueWihVersion:(NSString *)version withEcrId:(NSString *)ecrId withRequest:(NSString *)request withTotalAmount:(NSString *)totalAmount;

-(id)initWithGiftBalanceWihVersion:(NSString *)version withEcrId:(NSString *)ecrId withRequest:(NSString *)request withCardGroup:(NSString *)cardGroup;

-(NSString *)toString;

@end
