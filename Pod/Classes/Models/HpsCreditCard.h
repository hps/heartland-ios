#import <Foundation/Foundation.h>

@interface HpsCreditCard : NSObject
@property (nonatomic, strong) NSString *expMonth;
@property (nonatomic, strong) NSString *expYear;
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSString *cvv;

@end
