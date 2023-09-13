#ifndef GPTransactionSummary_h
#define GPTransactionSummary_h

#import <Foundation/Foundation.h>
#import <GlobalPaymentsApi/GPAddress.h>

@interface GPTransactionSummary : NSObject

@property (nonatomic, strong) NSString* accountDataSource;
@property (nonatomic, strong) NSString* adjustmentAmount;
@property (nonatomic, strong) NSString* adjustmentCurrency;
@property (nonatomic, strong) NSString* adjustmentReason;
@property (nonatomic, strong) NSString* amount;
@property (nonatomic, strong) NSString* aquirerReferenceNumber;
@property (nonatomic, strong) NSString* authorizedAmount;
@property (nonatomic, strong) NSString* authCode;
@property (nonatomic, strong) NSString* batchCloseDate;
@property (nonatomic, strong) NSString* batchSequenceNumber;
@property (nonatomic, strong) GPAddress* billingAddress;
@property (nonatomic, strong) NSString* captureAmount;
@property (nonatomic, strong) NSString* cardHolderFirstName;
@property (nonatomic, strong) NSString* cardHolderLastName;
@property (nonatomic, strong) NSString* cardSwiped;
@property (nonatomic, strong) NSString* cardType;
@property (nonatomic, strong) NSString* cavvResponseCode;
@property (nonatomic, strong) NSString* clerkId;
@property (nonatomic, strong) NSString* clientTransactionId;
@property (nonatomic, strong) NSString* companyName;
@property (nonatomic, strong) NSString* convenienceAmount;
@property (nonatomic, strong) NSString* currency;
@property (nonatomic, strong) NSString* customerFirstName;
@property (nonatomic, strong) NSString* customerId;
@property (nonatomic, strong) NSString* customerLastName;
@property (nonatomic) BOOL debtRepaymentIndicator;
@property (nonatomic, strong) NSString* depositAmount;
@property (nonatomic, strong) NSString* depositCurrency;
@property (nonatomic, strong) NSString* depositDate;
@property (nonatomic, strong) NSString* depositReference;
@property (nonatomic, strong) NSString* depositType;
@property (nonatomic, strong) NSString* transactionDescription;
@property (nonatomic, strong) NSString* deviceId;
@property (nonatomic, strong) NSString* emvChipCondition;
@property (nonatomic, strong) NSString* emvIssuerResponse;
@property (nonatomic, strong) NSString* entryMode;
@property (nonatomic, strong) NSString* fraudRuleInfo;
@property (nonatomic) BOOL fullyCaptured;
@property (nonatomic, strong) NSString* cashBackAmount;
@property (nonatomic, strong) NSString* gratuityAmount;
@property (nonatomic) BOOL hasEcomPaymentData;
@property (nonatomic) BOOL hasEmvTags;
@property (nonatomic, strong) NSString* invoiceNumber;
@property (nonatomic, strong) NSString* issuerResponseCode;
@property (nonatomic, strong) NSString* issuerResponseMessage;
@property (nonatomic, strong) NSString* issuerTransactionId;
@property (nonatomic, strong) NSString* gatewayResponseCode;
@property (nonatomic, strong) NSString* gatewayResponseMessage;
@property (nonatomic, strong) NSString* giftCurrency;
@property (nonatomic, strong) NSString* maskedAlias;
@property (nonatomic, strong) NSString* maskedCardNumber;
@property (nonatomic, strong) NSString* merchantCategory;
@property (nonatomic, strong) NSString* merchantDbaName;
@property (nonatomic, strong) NSString* merchantHierarchy;
@property (nonatomic, strong) NSString* merchantId;
@property (nonatomic, strong) NSString* merchantName;
@property (nonatomic, strong) NSString* merchantNumber;
@property (nonatomic) BOOL oneTimePayment;
@property (nonatomic, strong) NSString* orderId;
@property (nonatomic, strong) NSString* originalTransactionId;
@property (nonatomic, strong) NSString* paymentMethodKey;
@property (nonatomic, strong) NSString* paymentType;
@property (nonatomic, strong) NSString* poNumber;
@property (nonatomic, strong) NSString* recurringDataCode;
@property (nonatomic, strong) NSString* referenceNumber;
@property (nonatomic, strong) NSString* repeatCount;
@property (nonatomic, strong) NSString* responseDate;
@property (nonatomic, strong) NSString* scheduleId;
@property (nonatomic, strong) NSString* schemeReferenceData;
@property (nonatomic, strong) NSString* serviceName;
@property (nonatomic, strong) NSString* settlementAmount;
@property (nonatomic, strong) NSString* shippingAmount;
@property (nonatomic, strong) NSString* siteTrace;
@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) NSString* surchargeAmount;
@property (nonatomic, strong) NSString* taxAmount;
@property (nonatomic, strong) NSString* taxType;
@property (nonatomic, strong) NSString* terminalId;
@property (nonatomic, strong) NSString* tokenPanLastFour;
@property (nonatomic, strong) NSString* transactionDate;
@property (nonatomic, strong) NSString* transactionLocalDate;
@property (nonatomic, strong) NSString* transactionDescriptor;
@property (nonatomic, strong) NSString* transactionStatus;
@property (nonatomic, strong) NSString* transactionId;
@property (nonatomic, strong) NSString* uniqueDeviceId;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* transactionType;
@property (nonatomic, strong) NSString* cardEntryMethod;
@property (nonatomic, strong) NSString* amountDue;
@property (nonatomic) BOOL hostTimeout;

@end

#endif /* GPTransactionSummary_h */
