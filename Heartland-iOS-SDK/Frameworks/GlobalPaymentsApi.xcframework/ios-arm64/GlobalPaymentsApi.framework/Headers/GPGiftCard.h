#ifndef GPGiftCard_h
#define GPGiftCard_h

#import <Foundation/Foundation.h>
#import <GlobalPaymentsApi/GPPaymentMethod.h>
#import <GlobalPaymentsApi/GPEncryptionData.h>
#import <GlobalPaymentsApi/GPAuthorizationBuilder.h>

@interface GPGiftCard : GPPaymentMethod

@property (nonatomic, strong) NSString* alias;
@property (nonatomic, strong) NSString* number;
@property (nonatomic, strong) NSString* pin;
@property (nonatomic, strong) NSString* trackData;

- (GPAuthorizationBuilder*) charge;

@end

#endif /* GPGiftCard_h */
