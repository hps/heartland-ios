#ifndef GPTransaction_h
#define GPTransaction_h

#import <Foundation/Foundation.h>
#import <GlobalPaymentsApi/GPPaymentMethod.h>
#import <GlobalPaymentsApi/GPTransactionReference.h>
#import <GlobalPaymentsApi/GPManagementBuilder.h>

@interface GPTransaction : NSObject

@property (nonatomic, strong) NSString* authorizedAmount;
@property (nonatomic, strong) NSString* availableBalance;
@property (nonatomic, strong) NSString* avsResponseCode;
@property (nonatomic, strong) NSString* avsResponseMessage;
@property (nonatomic, strong) NSString* balanceAmount;
@property (nonatomic, strong) NSString* cardType;
@property (nonatomic, strong) NSString* cardLast4;
@property (nonatomic, strong) NSString* cavvResponseCode;
@property (nonatomic, strong) NSString* commercialIndicator;
@property (nonatomic, strong) NSString* cvnResponseCode;
@property (nonatomic, strong) NSString* cvnResponseMessage;
@property (nonatomic, strong) NSString* emvIssuerResponse;
@property (nonatomic) GPPaymentMethod* giftCard;
@property (nonatomic, strong) NSString* hostResponseDate;
@property (nonatomic, strong) NSString* pointsBalanceAmount;
@property (nonatomic, strong) NSString* recurringDataCode;
@property (nonatomic, strong) NSString* referenceNumber;
@property (nonatomic, strong) NSString* responseCode;
@property (nonatomic, strong) NSString* responseMessage;
@property (nonatomic, strong) NSString* serviceName;
@property (nonatomic, strong) NSString* token;
@property (nonatomic, strong) NSString* transactionDescriptor;
@property (nonatomic, strong) GPTransactionReference* transactionReference;

+ (instancetype) transactionFromId:(NSString*) transactionId;
+ (instancetype) transactionFromId:(NSString*) transactionId withPaymentMethodType:(GPPaymentMethodType) paymentMethodType;
+ (instancetype) transactionFromClientTransactionId:(NSString*) clientTransactionId;
+ (instancetype) transactionFromClientTransactionId:(NSString*) clientTransactionId withPaymentMethodType:(GPPaymentMethodType) paymentMethodType;
- (NSString*) authorizationCode;
- (NSString*) transactionId;
- (NSString*) clientTransactionId;

- (GPManagementBuilder*) capture;
- (GPManagementBuilder*) edit;
- (GPManagementBuilder*) refund;
- (GPManagementBuilder*) reverse;
- (GPManagementBuilder*) voidTransaction;

@end

#endif /* GPTransaction_h */
