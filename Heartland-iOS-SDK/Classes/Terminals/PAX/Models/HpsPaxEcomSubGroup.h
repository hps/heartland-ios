#import <Foundation/Foundation.h>
#import "HpsBinaryDataScanner.h"
#import "HpsTerminalEnums.h"
#import "HpsDeviceProtocols.h"

@interface HpsPaxEcomSubGroup : NSObject <IHPSRequestSubGroup>

@property (nonatomic,strong) NSString *ecomMode;
@property (nonatomic,strong) NSString *transactionType;
@property (nonatomic,strong) NSString *secureType;
@property (nonatomic,strong) NSString *orderNumber;
@property (nonatomic,strong) NSNumber *installments;
@property (nonatomic,strong) NSNumber *currentInstallment;

- (id)initWithBinaryReader: (HpsBinaryDataScanner*)br;
- (NSString*) getElementString;

@end
