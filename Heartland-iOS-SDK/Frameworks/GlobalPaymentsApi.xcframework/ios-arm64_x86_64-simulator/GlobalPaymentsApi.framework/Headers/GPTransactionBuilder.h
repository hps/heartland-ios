#ifndef GPTransactionBuilder_h
#define GPTransactionBuilder_h

#import <Foundation/Foundation.h>
#import <GlobalPaymentsApi/GPEnums.h>
#import <GlobalPaymentsApi/GPPaymentMethod.h>

@class GPTransaction;

@interface GPTransactionBuilder : NSObject

@property (nonatomic, strong) GPPaymentMethod* paymentMethod;
@property (nonatomic) GPTransactionModifier transactionModifier;
@property (nonatomic) GPTransactionType transactionType;

- (void) execute:(void(^)(GPTransaction*, NSError*))completionHandler;
- (void) execute:(void(^)(GPTransaction*, NSError*))completionHandler withConfigName:(NSString*) name;

- (instancetype) withPaymentMethod:(GPPaymentMethod*) value;
- (instancetype) withTransactionModifier:(GPTransactionModifier) value;
- (instancetype) withTransactionType:(GPTransactionType) value;

@end

#endif /* GPTransactionBuilder_h */
