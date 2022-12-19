#import <Foundation/Foundation.h>
#import "HpsDeviceProtocols.h"

@interface HpsPaxAccountRequest : NSObject <IHPSRequestSubGroup>

@property (nonatomic,strong) NSString *accountNumber;
@property (nonatomic,strong) NSString *expd;
@property (nonatomic,strong) NSString *cvvCode;
@property (nonatomic,strong) NSString *ebtType;
@property (nonatomic,strong) NSString *voucherNumber;
@property (nonatomic,strong) NSString *dupOverrideFlag;

- (NSString*) getElementString;

@end
