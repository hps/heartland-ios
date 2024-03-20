#ifndef GPSurchargeEligibilityLookupBuilder_h
#define GPSurchargeEligibilityLookupBuilder_h

#import <Foundation/Foundation.h>
#import <GlobalPaymentsApi/GPTransactionBuilder.h>
#import <GlobalPaymentsApi/GPEnums.h>
#import <GlobalPaymentsApi/GPAddress.h>
#import <GlobalPaymentsApi/AutoSubstantiation.h>

@interface GPSurchargeEligibilityLookupBuilder : GPTransactionBuilder
@property (nonatomic) BOOL allowDuplicates;
@property (nonatomic) BOOL allowPartialAuth;
@property (nonatomic) BOOL cpcReq;
@property (nonatomic, strong) NSString* amount;
@property (nonatomic, strong) GPAddress* billingAddress;
@property (nonatomic) GPEMVChipCondition chipCondition;
@property (nonatomic, strong) NSString* clientTransactionId;
@property (nonatomic, strong) NSString* convenienceAmount;
@property (nonatomic, strong) NSString* customerId;
@property (nonatomic, strong) NSString* dynamicDescriptor;
@property (nonatomic, strong) NSString* gratuity;
@property (nonatomic, strong) NSString* invoiceNumber;
@property (nonatomic) BOOL level2Request DEPRECATED_MSG_ATTRIBUTE("Please, use cpcReq instead");
@property (nonatomic, strong) NSString* offlineAuthCode;
@property (nonatomic) BOOL requestMultiUseToken;
@property (nonatomic, strong) GPAddress* shippingAddress;
@property (nonatomic, strong) NSString* shippingAmount;
@property (nonatomic, strong) NSString* surchargeAmount;
@property (nonatomic, strong) NSString* tagData;
@property (nonatomic, strong) NSString* transactionDescription;
@property (nonatomic, strong) AutoSubstantiation* autoSubstantiation;
@end

#endif /* GPSurchargeEligibilityLookupBuilder */
