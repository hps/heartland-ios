#import "HpsHpaRequest.h"

@implementation HpsHpaRequest

#pragma mark :Credit

-(id)initWithCreditSaleRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withCardGroup:(NSString *)cardGroup withConfirmAmount:(NSString *)confirmAmount withBaseAmount:(NSString *)baseAmount withTipAmount:(NSString*)tipAmount withTaxAmount:(NSString *)taxAmount withEBTAmount:(NSString*)ebtAmount withTotalAmount:(NSString *)totalAmount 
{
	if (self = [super init])
		{
		[HpsHpaSharedParams getInstance].class_type = REQUEST;
		self.Version = version;
		self.ECRId = EcrID;
		self.Request = requset;
		self.CardGroup = cardGroup;
		self.ConfirmAmount = confirmAmount;
		self.BaseAmount = baseAmount;
		self.TipAmount = tipAmount;
		self.TaxAmount = taxAmount;
		self.EBTAmount = ebtAmount;
		self.TotalAmount = totalAmount;
		}

	return self;
}

-(id)initWithCreditRefundRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withCardGroup:(NSString *)cardGroup withConfirmAmount:(NSString *)confirmAmount withInvoiceNbr:(NSString*)invoiceNbr withTotalAmount:(NSString *)totalAmount
{
	if (self = [super init])
		{
		[HpsHpaSharedParams getInstance].class_type = REQUEST;
		self.Version = version;
		self.ECRId = EcrID;
		self.Request = requset;
		self.CardGroup = cardGroup;
		self.ConfirmAmount = confirmAmount;
		self.InvoiceNbr = invoiceNbr;
		self.TotalAmount = totalAmount;
		}

	return self;
}

-(id) initWithCreditAuthRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withConfirmAmount:(NSString *)confirmAmount withTotalAmount:(NSString *)totalAmount
{
	if (self = [super init])
		{
		[HpsHpaSharedParams getInstance].class_type = REQUEST;
		self.Version = version;
		self.ECRId = EcrID;
		self.Request = requset;
		self.ConfirmAmount = confirmAmount;
		self.TotalAmount = totalAmount;
		}

	return self;
}

-(id) initWithCreditAuthCompleteWithVersion:(NSString *)version withEcrId:(NSString *)ecrID withRequest:(NSString *)request withTransactionId:(NSString *)transactionId withTotalAmount:(NSString *)totalAmount withTipAmount:(NSString *)tipAmount{

	if (self = [super init])
		{
		[HpsHpaSharedParams getInstance].class_type = REQUEST;
		self.Version = version;
		self.ECRId = ecrID;
		self.Request = request;
		self.TransactionId = transactionId;
		self.TotalAmount = totalAmount;
		self.TipAmount = tipAmount;
		}
	return self;

}


-(id) initWithVoidTransacationRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withCardGroup:(NSString*)cardGroup withTransactionID:(NSString *)transactionID{
	if (self = [super init])
		{
		[HpsHpaSharedParams getInstance].class_type = REQUEST;
		self.Version = version;
		self.ECRId = EcrID;
		self.Request = requset;
		self.CardGroup = cardGroup;
		self.TransactionId = transactionID;
		}

	return self;
}

-(id) initWithCreditTipAdjustwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withTransactionID:(NSString *)transactionID withTipAmount:(NSString *)tipAmount
{
	if (self = [super init])
		{
		[HpsHpaSharedParams getInstance].class_type = REQUEST;
		self.Version = version;
		self.ECRId = EcrID;
		self.Request = requset;
		self.TransactionId = transactionID;
		self.TipAmount = tipAmount;
		}

	return self;
}

-(id)initWithCreditVerifyRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withCardGroup:(NSString *)cardGroup {

	if (self = [super init])
		{
		[HpsHpaSharedParams getInstance].class_type = REQUEST;
		self.Version = version;
		self.ECRId = EcrID;
		self.Request = requset;
		self.CardGroup = cardGroup;
		}

	return self;
}

#pragma mark :Debit
-(id)initWithDebitSaleRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withCardGroup:(NSString *)cardGroup withConfirmAmount:(NSString *)confirmAmount withInvoiceNbr:(NSString*)invoiceNbr withBaseAmount:(NSString *)baseAmount withTaxAmount:(NSString *)taxAmount withTotalAmount:(NSString *)totalAmount withServerLabel:serverLabel{
	if (self = [super init])
		{
		[HpsHpaSharedParams getInstance].class_type = REQUEST;
		self.Version = version;
		self.ECRId = EcrID;
		self.Request = requset;
		self.CardGroup = cardGroup;
		self.ConfirmAmount = confirmAmount;
		self.InvoiceNbr = invoiceNbr;
		self.BaseAmount = baseAmount;
		self.TaxAmount = taxAmount;
		self.TotalAmount = totalAmount;
		self.ServerLabel = serverLabel;
		}

	return self;
}

-(id)initWithDebitRefundRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString *)requset withCardGroup:(NSString *)cardGroup withConfirmAmount:(NSString *)confirmAmount withInvoiceNbr:(NSString *)invoiceNbr withTotalAmount:(NSString *)totalAmount{
	if (self = [super init])
		{
		[HpsHpaSharedParams getInstance].class_type = REQUEST;
		self.Version = version;
		self.ECRId = EcrID;
		self.Request = requset;
		self.CardGroup = cardGroup;
		self.ConfirmAmount = confirmAmount;
		self.InvoiceNbr = invoiceNbr;
		self.TotalAmount = totalAmount;
		}
	return self;
}

#pragma mark :Gift
-(id)initWithAddValueWihVersion:(NSString *)version withEcrId:(NSString *)ecrId withRequest:(NSString *)request withTotalAmount:(NSString *)totalAmount{
	if(self = [super init])
		{
		[HpsHpaSharedParams getInstance].class_type = REQUEST;
		self.Version = version;
		self.ECRId = ecrId;
		self.Request = request;
		self.TotalAmount = totalAmount;
		}

	return self;
}


-(id)initWithGiftBalanceWihVersion:(NSString *)version withEcrId:(NSString *)ecrId withRequest:(NSString *)request withCardGroup:(NSString *)cardGroup{
	if(self = [super init])
		{
		[HpsHpaSharedParams getInstance].class_type = REQUEST;
		self.Version = version;
		self.ECRId = ecrId;
		self.Request = request;
		self.CardGroup = cardGroup;
		}

	return self;

}
#pragma mark :EBT
-(id)initWithEBTSaleRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withCardGroup:(NSString *)cardGroup withConfirmAmount:(NSString *)confirmAmount withBaseAmount:(NSString *)baseAmount withTipAmount:(NSString*)tipAmount withTaxAmount:(NSString *)taxAmount withEBTAmount:(NSString*)ebtAmount withTotalAmount:(NSString *)totalAmount
{
    if (self = [super init])
    {
        [HpsHpaSharedParams getInstance].class_type = REQUEST;
        self.Version = version;
        self.ECRId = EcrID;
        self.Request = requset;
        self.CardGroup = cardGroup;
        self.ConfirmAmount = confirmAmount;
        self.BaseAmount = baseAmount;
        self.TipAmount = tipAmount;
        self.TaxAmount = taxAmount;
        self.EBTAmount = ebtAmount;
        self.TotalAmount = totalAmount;
    }
    
    return self;
}

-(id)initWithEBTRefundRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString *)requset withCardGroup:(NSString *)cardGroup withConfirmAmount:(NSString *)confirmAmount withInvoiceNbr:(NSString *)invoiceNbr withTotalAmount:(NSString *)totalAmount{
    if (self = [super init])
    {
        [HpsHpaSharedParams getInstance].class_type = REQUEST;
        self.Version = version;
        self.ECRId = EcrID;
        self.Request = requset;
        self.CardGroup = cardGroup;
        self.ConfirmAmount = confirmAmount;
        self.InvoiceNbr = invoiceNbr;
        self.TotalAmount = totalAmount;
    }
    return self;
}

-(id)initWithEBTBalanceWihVersion:(NSString *)version withEcrId:(NSString *)ecrId withRequest:(NSString *)request withCardGroup:(NSString *)cardGroup{
    if(self = [super init])
    {
        [HpsHpaSharedParams getInstance].class_type = REQUEST;
        self.Version = version;
        self.ECRId = ecrId;
        self.Request = request;
        self.CardGroup = cardGroup;
    }
    
    return self;
    
}
#pragma mark :Start Download Request
-(id)initToStartDownloadWithVersion:(NSString *)version withEcrId:(NSString *)ecrId withRequest:(NSString *)request withHUDSURL:(NSString*)url withHUDSPORT:(NSString*)hudSport withTerminal:(NSString*)terminal withAppId:(NSString*)appId withDownloadType:(NSString*)downloadType andDownloadTime:(NSString*)downloadTime {

	if(self = [super init])
		{
		[HpsHpaSharedParams getInstance].class_type = REQUEST;
		self.Version = version;
		self.ECRId = ecrId;
		self.Request = request;
		self.HUDSURL = url;
		self.HUDSPORT = hudSport;
		self.TerminalID = terminal;
		self.ApplicationID = appId;
		self.DownloadType = downloadType;
		self.DownloadTime = downloadTime;
		}

	return self;

}

#pragma mark :Start Card Request
-(id)initToStartCardWithVersion:(NSString *)version withEcrId:(NSString *)ecrId withRequest:(NSString *)request andCardGroup:(NSString*)cardGroup {

	if(self = [super init])
		{
		[HpsHpaSharedParams getInstance].class_type = REQUEST;
		self.Version = version;
		self.ECRId = ecrId;
		self.Request = request;
		self.CardGroup = cardGroup;
		}

	return self;

}

#pragma mark :Line Item
-(id)initToAddLineItemWithVersion:(NSString *)version withEcrId:(NSString *)ecrId andRequest:(NSString *)request {

	if(self = [super init])
		{
		[HpsHpaSharedParams getInstance].class_type = REQUEST;
		self.Version = version;
		self.ECRId = ecrId;
		self.Request = request;
		}

	return self;
}
#pragma mark :SAF
-(id)initSendSAFWithVersion:(NSString *)version withEcrId:(NSString *)ecrId andRequest:(NSString *)request {
   
    if(self = [super init])
    {
        [HpsHpaSharedParams getInstance].class_type = REQUEST;
        self.Version = version;
        self.ECRId = ecrId;
        self.Request = request;
    }
    
    return self;
}
  
  #pragma mark : Diagnostic Report
-(id)initToGetDiagnosticReport:(NSString *)version withEcrId:(NSString *)ecrId withFieldCount:(NSString*)fieldCount andRequest:(NSString *)request {
    
    if(self = [super init])
    {
        [HpsHpaSharedParams getInstance].class_type = REQUEST;
        self.Version = version;
        self.ECRId = ecrId;
        self.Request = request;
        self.FieldCount = fieldCount;
    }
    
    return self;
}

#pragma mark :EOD

-(id)initExecuteEODWithVersion:(NSString *)version withEcrId:(NSString *)ecrId andRequest:(NSString *)request {
    
    if(self = [super init])
    {
        [HpsHpaSharedParams getInstance].class_type = REQUEST;
        self.Version = version;
        self.ECRId = ecrId;
        self.Request = request;
    }
    
    return self;
}

#pragma mark :Send File
-(id)initToSendFileNameWithVersion:(NSString *)version withEcrId:(NSString *)ecrId withRequest:(NSString *)request withFileName:(NSString*)fileName withFileSize:(NSString*)fileSize andMultipleMessage:(NSString*)multipleMessage {
    
    if(self = [super init])
    {
        [HpsHpaSharedParams getInstance].class_type = REQUEST;
        self.Version = version;
        self.ECRId = ecrId;
        self.Request = request;
        self.FileName = fileName;
        self.FileSize = fileSize;
        self.MultipleMessage = multipleMessage;
    }
    return self;
}

-(id)initToSendFileDataWithVersion:(NSString *)version withEcrId:(NSString *)ecrId withRequest:(NSString *)request withFileData:(NSString*)fileData andMultipleMessage:(NSString*)multipleMessage {
    
    if(self = [super init])
    {
        [HpsHpaSharedParams getInstance].class_type = REQUEST;
        self.Version = version;
        self.ECRId = ecrId;
        self.Request = request;
        self.FileData = fileData;
        self.MultipleMessage = multipleMessage;
    }
    return self;
}
-(NSString *)toString
{
	return [NSString stringWithFormat:@"%@-%@-%@-%@-%@-%@-%@",_ECRId,_Version,_SIPId,_Response,_MultipleMessage,_Result,_ResultText];
}

@end
