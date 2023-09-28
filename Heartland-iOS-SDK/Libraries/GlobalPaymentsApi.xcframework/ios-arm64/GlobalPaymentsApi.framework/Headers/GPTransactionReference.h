#ifndef GPTransactionReference_h
#define GPTransactionReference_h

#import <Foundation/Foundation.h>
#import <GlobalPaymentsApi/GPPaymentMethod.h>
#import <GlobalPaymentsApi/GPEnums.h>

@interface GPTransactionReference : GPPaymentMethod

@property (nonatomic, strong) NSString* authCode;
@property (nonatomic, strong) NSString* batchNumber;
@property (nonatomic, strong) NSString* transactionId;
@property (nonatomic, strong) NSString* clientTransactionId;

@end

#endif /* GPTransactionReference_h */
