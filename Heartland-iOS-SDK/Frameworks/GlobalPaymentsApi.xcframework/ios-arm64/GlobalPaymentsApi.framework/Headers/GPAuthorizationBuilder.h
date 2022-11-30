#ifndef GPAuthorizationBuilder_h
#define GPAuthorizationBuilder_h

#import <Foundation/Foundation.h>
#import <GlobalPaymentsApi/GPTransactionBuilder.h>
#import <GlobalPaymentsApi/GPEnums.h>
#import <GlobalPaymentsApi/GPAddress.h>

@interface GPAuthorizationBuilder : GPTransactionBuilder

@property (nonatomic) BOOL allowDuplicates;
@property (nonatomic) BOOL allowPartialAuth;
@property (nonatomic, strong) NSString* amount;
@property (nonatomic, strong) GPAddress* billingAddress;
@property (nonatomic) GPEMVChipCondition chipCondition;
@property (nonatomic, strong) NSString* clientTransactionId;
@property (nonatomic, strong) NSString* convenienceAmount;
@property (nonatomic, strong) NSString* customerId;
@property (nonatomic, strong) NSString* dynamicDescriptor;
@property (nonatomic, strong) NSString* gratuity;
@property (nonatomic, strong) NSString* invoiceNumber;
@property (nonatomic) BOOL level2Request;
@property (nonatomic, strong) NSString* offlineAuthCode;
@property (nonatomic) BOOL requestMultiUseToken;
@property (nonatomic, strong) GPAddress* shippingAddress;
@property (nonatomic, strong) NSString* shippingAmount;
@property (nonatomic, strong) NSString* surchargeAmount;
@property (nonatomic, strong) NSString* tagData;
@property (nonatomic, strong) NSString* transactionDescription;

- (instancetype) withAddress:(GPAddress*) value;
- (instancetype) withAddress:(GPAddress*) value withAddressType:(GPAddressType) addressType;
- (instancetype) withAllowDuplicates:(BOOL) value;
- (instancetype) withAllowPartialAuth:(BOOL) value;
- (instancetype) withAmount:(NSString*) value;
- (instancetype) withChipCondition:(GPEMVChipCondition) value;
- (instancetype) withClientTransactionId:(NSString*) value;
- (instancetype) withCommercialRequest:(BOOL) value;
- (instancetype) withConvenienceAmount:(NSString*) value;
- (instancetype) withCustomerId:(NSString*) value;
- (instancetype) withDynamicDescriptor:(NSString*) value;
- (instancetype) withGratuity:(NSString*) value;
- (instancetype) withInvoiceNumber:(NSString*) value;
- (instancetype) withOfflineAuthCode:(NSString*) value;
- (instancetype) withRequestMultiUseToken:(BOOL) value;
- (instancetype) withShippingAmount:(NSString*) value;
- (instancetype) withSurchargeAmount:(NSString*) value;
- (instancetype) withTagData:(NSString*) value;
- (instancetype) withTransactionDescription:(NSString*) value;

@end

#endif /* GPAuthorizationBuilder_h */
