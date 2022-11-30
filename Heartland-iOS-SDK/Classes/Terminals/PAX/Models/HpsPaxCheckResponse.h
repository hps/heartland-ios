#import <Foundation/Foundation.h>
#import "HpsBinaryDataScanner.h"
#import "HpsTerminalEnums.h"


@interface HpsPaxCheckResponse : NSObject

@property (nonatomic,strong) NSString *saleType;
@property (nonatomic,strong) NSString *routingNumber;
@property (nonatomic,strong) NSString *accountNumber;
@property (nonatomic,strong) NSString *checkNumber;
@property (nonatomic,strong) NSString *checkType;
@property (nonatomic,strong) NSString *idType;
@property (nonatomic,strong) NSString *idValue;
@property (nonatomic,strong) NSString *dob;
@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic,strong) NSString *zipCode;

- (id)initWithBinaryReader: (HpsBinaryDataScanner*)br;
@end
