#import <Foundation/Foundation.h>
#import "HpsTerminalResponse.h"
#import "NSObject+ObjectMap.h"
#import "HpsHpaSharedParams.h"

@interface HpsHpaRequest : NSObject

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
@property (nonatomic,retain) NSString *EBTAmount;
@property (nonatomic,retain) NSString *TotalAmount;
@property (nonatomic,retain) NSString *ServerLabel;
@property (nonatomic, readwrite) int RequestId;
	//Void
@property (nonatomic,retain) NSString *TransactionId;
	//Tip
@property (nonatomic,retain) NSString *TipAmount;
	//StartDownload
@property (nonatomic,retain) NSString *HUDSURL;
@property (nonatomic,retain) NSString *HUDSPORT;
@property (nonatomic,retain) NSString *TerminalID;
@property (nonatomic,retain) NSString *ApplicationID;
@property (nonatomic,retain) NSString *DownloadType;
@property (nonatomic,retain) NSString *DownloadTime;
	//LineItem
@property (nonatomic,retain) NSString *LineItemTextLeft;
@property (nonatomic,retain) NSString *LineItemTextRight;
@property (nonatomic,retain) NSString *LineItemRunningTextLeft;
@property (nonatomic,retain) NSString *LineItemRunningTextRight;
    //Diagnostic
@property (nonatomic,retain) NSString *FieldCount;

//SendFile
@property (nonatomic,retain) NSString *FileName;
@property (nonatomic,retain) NSString *FileSize;
@property (nonatomic,retain) NSString *FileData;

	//Credit

-(id)initWithCreditSaleRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withCardGroup:(NSString *)cardGroup withConfirmAmount:(NSString *)confirmAmount withBaseAmount:(NSString *)baseAmount withTipAmount:(NSString*)tipAmount withTaxAmount:(NSString *)taxAmount withEBTAmount:(NSString*)ebtAmount withTotalAmount:(NSString *)totalAmount;

-(id)initWithCreditRefundRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withCardGroup:(NSString *)cardGroup withConfirmAmount:(NSString *)confirmAmount withInvoiceNbr:(NSString*)invoiceNbr withTotalAmount:(NSString *)totalAmount;

-(id)initWithCreditAuthRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withConfirmAmount:(NSString *)confirmAmount withTotalAmount:(NSString *)totalAmount;

-(id) initWithCreditAuthCompleteWithVersion:(NSString *)version withEcrId:(NSString *)ecrID withRequest:(NSString *)request withTransactionId:(NSString *)transactionId withTotalAmount:(NSString *)totalAmount withTipAmount:(NSString *)tipAmount;

-(id) initWithVoidTransacationRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withCardGroup:(NSString*)cardGroup withTransactionID:(NSString *)transactionID;

-(id) initWithCreditTipAdjustwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withTransactionID:(NSString *)transactionID withTipAmount:(NSString *)tipAmount;

-(id)initWithCreditVerifyRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withCardGroup:(NSString *)cardGroup;


	//Debit

-(id)initWithDebitSaleRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withCardGroup:(NSString *)cardGroup withConfirmAmount:(NSString *)confirmAmount withInvoiceNbr:(NSString*)invoiceNbr withBaseAmount:(NSString *)baseAmount withTaxAmount:(NSString *)taxAmount withTotalAmount:(NSString *)totalAmount withServerLabel:serverLabel;

-(id)initWithDebitRefundRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withCardGroup:(NSString *)cardGroup withConfirmAmount:(NSString *)confirmAmount withInvoiceNbr:(NSString*)invoiceNbr withTotalAmount:(NSString *)totalAmount;

	//Gift
-(id)initWithAddValueWihVersion:(NSString *)version withEcrId:(NSString *)ecrId withRequest:(NSString *)request withTotalAmount:(NSString *)totalAmount;

-(id)initWithGiftBalanceWihVersion:(NSString *)version withEcrId:(NSString *)ecrId withRequest:(NSString *)request withCardGroup:(NSString *)cardGroup;

//EBT
-(id)initWithEBTSaleRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withCardGroup:(NSString *)cardGroup withConfirmAmount:(NSString *)confirmAmount withBaseAmount:(NSString *)baseAmount withTipAmount:(NSString*)tipAmount withTaxAmount:(NSString *)taxAmount withEBTAmount:(NSString*)ebtAmount withTotalAmount:(NSString *)totalAmount;
-(id)initWithEBTRefundRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString *)requset withCardGroup:(NSString *)cardGroup withConfirmAmount:(NSString *)confirmAmount withInvoiceNbr:(NSString *)invoiceNbr withTotalAmount:(NSString *)totalAmount;
-(id)initWithEBTBalanceWihVersion:(NSString *)version withEcrId:(NSString *)ecrId withRequest:(NSString *)request withCardGroup:(NSString *)cardGroup;

	//Start Download
-(id)initToStartDownloadWithVersion:(NSString *)version withEcrId:(NSString *)ecrId withRequest:(NSString *)request withHUDSURL:(NSString*)url withHUDSPORT:(NSString*)hudSport withTerminal:(NSString*)terminal withAppId:(NSString*)appId withDownloadType:(NSString*)downloadType andDownloadTime:(NSString*)downloadTime;

	//Start Card
-(id)initToStartCardWithVersion:(NSString *)version withEcrId:(NSString *)ecrId withRequest:(NSString *)request andCardGroup:(NSString*)cardGroup;

	//LineItem
-(id)initToAddLineItemWithVersion:(NSString *)version withEcrId:(NSString *)ecrId andRequest:(NSString *)request;

   //Diagnostic Report
-(id)initToGetDiagnosticReport:(NSString *)version withEcrId:(NSString *)ecrId withFieldCount:(NSString*)fieldCount andRequest:(NSString *)request;

   //SAF
-(id)initSendSAFWithVersion:(NSString *)version withEcrId:(NSString *)ecrId andRequest:(NSString *)request;

    //EOD
-(id)initExecuteEODWithVersion:(NSString *)version withEcrId:(NSString *)ecrId andRequest:(NSString *)request;

//Send File
-(id)initToSendFileNameWithVersion:(NSString *)version withEcrId:(NSString *)ecrId withRequest:(NSString *)request withFileName:(NSString*)fileName withFileSize:(NSString*)fileSize andMultipleMessage:(NSString*)multipleMessage;
-(id)initToSendFileDataWithVersion:(NSString *)version withEcrId:(NSString *)ecrId withRequest:(NSString *)request withFileData:(NSString*)fileData andMultipleMessage:(NSString*)multipleMessage;

-(NSString *)toString;

@end

