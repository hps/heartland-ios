#ifndef GPManagementBuilder_h
#define GPManagementBuilder_h

#import <Foundation/Foundation.h>
#import <GlobalPaymentsAPi/GPTransactionBuilder.h>
#import <GlobalPaymentsApi/GPEnums.h>

@interface GPManagementBuilder : GPTransactionBuilder

@property (nonatomic, strong) NSString* amount;
@property (nonatomic, strong) NSString* authAmount;
@property (nonatomic, strong) NSString* currency;
@property (nonatomic, strong) NSString* customerId;
@property (nonatomic, strong) NSString* gratuity;
@property (nonatomic, strong) NSString* invoiceNumber;
@property (nonatomic, strong) NSString* payerAuthenticationResponse;
@property (nonatomic, strong) NSString* poNumber;
@property (nonatomic, strong) NSString* tagData;
@property (nonatomic, strong) NSString* taxAmount;
@property (nonatomic) GPTaxType taxType;
@property (nonatomic, strong) NSString* transactionDescription;

- (NSString*) authorizationCode;
- (NSString*) clientTransactionId;
- (NSString*) transactionId;
- (instancetype) withAmount:(NSString*) value;
- (instancetype) withAuthAmount:(NSString*) value;
- (instancetype) withCurrency:(NSString*) value;
- (instancetype) withCustomerId:(NSString*) value;
- (instancetype) withGratuity:(NSString*) value;
- (instancetype) withInvoiceNumber:(NSString*) value;
- (instancetype) withPayerAuthenticationResponse:(NSString*) value;
- (instancetype) withPoNumber:(NSString*) value;
- (instancetype) withTagData:(NSString*) value;
- (instancetype) withTaxAmount:(NSString*) value;
- (instancetype) withTaxType:(GPTaxType) value;
- (instancetype) withTransactionDescription:(NSString*) value;

@end

#endif /* GPManagementBuilder_h */
