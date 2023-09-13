#ifndef GPPaymentMethod_h
#define GPPaymentMethod_h

#import <Foundation/Foundation.h>
#import <GlobalPaymentsApi/GPEncryptionData.h>
#import <GlobalPaymentsApi/GPEnums.h>

@interface GPPaymentMethod : NSObject

@property (nonatomic, strong) GPEncryptionData* encryptionData;
@property (nonatomic) GPPaymentMethodType paymentMethodType;

@end

#endif /* GPPaymentMethod_h */
