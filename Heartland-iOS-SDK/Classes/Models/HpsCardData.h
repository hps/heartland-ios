#import <Foundation/Foundation.h>
#import "HpsTokenData.h"

@interface HpsCardData : NSObject

@property (nonatomic, strong) HpsTokenData *tokenResponse;
@property (nonatomic, strong) NSString *expMonth;
@property (nonatomic) BOOL cardPresent;
@property (nonatomic, strong) NSString *expYear;
@property (nonatomic) BOOL readerPresent;
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic) BOOL requestToken;
@property (nonatomic, strong) NSString* cvv2;

- (NSString*) toXML;

@end
