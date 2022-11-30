#ifndef GPCredit_h
#define GPCredit_h

#import <Foundation/Foundation.h>
#import <GlobalPaymentsApi/GPEnums.h>
#import <GlobalPaymentsApi/GPPaymentMethod.h>
#import <GlobalPaymentsApi/GPAuthorizationBuilder.h>

@interface GPCredit : GPPaymentMethod

- (GPAuthorizationBuilder*) authorize;
- (GPAuthorizationBuilder*) charge;
- (GPAuthorizationBuilder*) refund;
- (GPAuthorizationBuilder*) verify;

@end

#endif /* GPCredit_h */
