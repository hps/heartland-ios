	//  Copyright (c) 2017 Heartland Payment Systems. All rights reserved.

#import "HpsHeartSipRequest.h"

@implementation HpsHeartSipRequest

#pragma mark :Credit

-(id)initWithCreditSaleRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withCardGroup:(NSString *)cardGroup withConfirmAmount:(NSString *)confirmAmount withInvoiceNbr:(NSString*)invoiceNbr withBaseAmount:(NSString *)baseAmount withTaxAmount:(NSString *)taxAmount withTotalAmount:(NSString *)totalAmount withServerLabel:serverLabel
{
	if (self = [super init])
		{
		[HpsHeartSipSharedParams getInstance].class_type = REQUEST;
		self.Version = version;
		self.ECRId = EcrID;
		self.Request = requset;
		self.CardGroup = cardGroup;
		self.ConfirmAmount = confirmAmount;
		self.InvoiceNbr = invoiceNbr;
		self.BaseAmount = baseAmount;
		self.TaxAmount = taxAmount;
		self.TotalAmount = totalAmount;
		self.ServerLabel =serverLabel;
		}

	return self;
}

-(id)initWithCreditRefundRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withCardGroup:(NSString *)cardGroup withConfirmAmount:(NSString *)confirmAmount withInvoiceNbr:(NSString*)invoiceNbr withTotalAmount:(NSString *)totalAmount
{
	if (self = [super init])
		{
		[HpsHeartSipSharedParams getInstance].class_type = REQUEST;
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

-(id) initWithCreditAuthRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withConfirmAmount:(NSString *)confirmAmount withInvoiceNbr:(NSString*)invoiceNbr withTotalAmount:(NSString *)totalAmount
{
	if (self = [super init])
		{
		[HpsHeartSipSharedParams getInstance].class_type = REQUEST;
		self.Version = version;
		self.ECRId = EcrID;
		self.Request = requset;
		self.ConfirmAmount = confirmAmount;
		self.InvoiceNbr = invoiceNbr;
		self.TotalAmount = totalAmount;
		}

	return self;
}

-(id) initWithCreditAuthCompleteWithVersion:(NSString *)version withEcrId:(NSString *)ecrID withRequest:(NSString *)request withTransactionId:(NSString *)transactionId withConfirmAmount:(NSString *)confirmAmount withTotalAmount:(NSString *)totalAmount withTipAmount:(NSString *)tipAmount{

	if (self = [super init])
		{
		[HpsHeartSipSharedParams getInstance].class_type = REQUEST;
		self.Version = version;
		self.ECRId = ecrID;
		self.Request = request;
		self.TransactionId = transactionId;
		self.ConfirmAmount = confirmAmount;
		self.TotalAmount = totalAmount;
		self.TipAmount = tipAmount;
		}
	return self;

}


-(id) initWithVoidTransacationRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withTransactionID:(NSString *)transactionID{
	if (self = [super init])
		{
		[HpsHeartSipSharedParams getInstance].class_type = REQUEST;
		self.Version = version;
		self.ECRId = EcrID;
		self.Request = requset;
		self.TransactionId = transactionID;
		}

	return self;
}

-(id) initWithCreditTipAdjustwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withTransactionID:(NSString *)transactionID withTipAmount:(NSString *)tipAmount
{
	if (self = [super init])
		{
		[HpsHeartSipSharedParams getInstance].class_type = REQUEST;
		self.Version = version;
		self.ECRId = EcrID;
		self.Request = requset;
		self.TransactionId = transactionID;
		self.TipAmount = tipAmount;
		}

	return self;
}


#pragma mark :Debit
-(id)initWithDebitSaleRequestwithVersion:(NSString *)version withEcrId:(NSString *)EcrID withRequest:(NSString*)requset withCardGroup:(NSString *)cardGroup withConfirmAmount:(NSString *)confirmAmount withInvoiceNbr:(NSString*)invoiceNbr withBaseAmount:(NSString *)baseAmount withTaxAmount:(NSString *)taxAmount withTotalAmount:(NSString *)totalAmount withServerLabel:serverLabel{
	if (self = [super init])
		{
		[HpsHeartSipSharedParams getInstance].class_type = REQUEST;
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
		[HpsHeartSipSharedParams getInstance].class_type = REQUEST;
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
		[HpsHeartSipSharedParams getInstance].class_type = REQUEST;
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
		[HpsHeartSipSharedParams getInstance].class_type = REQUEST;
		self.Version = version;
		self.ECRId = ecrId;
		self.Request = request;
		self.CardGroup = cardGroup;
		}

	return self;

}

-(NSString *)toString
{
	return [NSString stringWithFormat:@"%@-%@-%@-%@-%@-%@-%@",_ECRId,_Version,_SIPId,_Response,_MultipleMessage,_Result,_ResultText];
}

@end
