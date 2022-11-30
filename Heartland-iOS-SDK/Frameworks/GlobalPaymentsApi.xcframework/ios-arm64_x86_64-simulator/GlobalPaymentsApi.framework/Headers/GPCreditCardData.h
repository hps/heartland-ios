#ifndef GPCreditCardData_h
#define GPCreditCardData_h

#import <Foundation/Foundation.h>
#import <GlobalPaymentsApi/GlobalPaymentsApi.h>

@interface GPCreditCardData : GPCredit

@property (nonatomic, strong) NSString* number;
@property (nonatomic, strong) NSString* expMonth;
@property (nonatomic, strong) NSString* expYear;
@property (nonatomic, strong) NSString* cvn;
@property (nonatomic, strong) NSString* cardHolderName;
@property (nonatomic, strong) NSString* token;
@property (nonatomic) BOOL cardPresent;
@property (nonatomic) BOOL readerPresent;

@end

#endif /* GPCreditCardData_h */
