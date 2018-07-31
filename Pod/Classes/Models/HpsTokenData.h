#import <Foundation/Foundation.h>

@interface HpsTokenData : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *param;
@property (nonatomic, strong) NSString *tokenValue;
@property (nonatomic, strong) NSString *tokenExpire;
@property (nonatomic, strong) NSString *tokenType;
@property (nonatomic, strong) NSString *cardNumber;
- (NSString*) toXML;
@end
