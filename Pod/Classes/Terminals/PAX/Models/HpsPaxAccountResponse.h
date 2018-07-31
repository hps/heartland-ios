#import <Foundation/Foundation.h>
#import "HpsBinaryDataScanner.h"
#import "HpsTerminalEnums.h"

@interface HpsPaxAccountResponse : NSObject

@property (nonatomic,strong) NSString *accountNumber;
@property (nonatomic) HpsPaxEntryModes entryMode;
@property (nonatomic,strong) NSString *expireDate;
@property (nonatomic,strong) NSString *ebtType;
@property (nonatomic,strong) NSString *voucherNumber;
@property (nonatomic,strong) NSString *nAccountNumber;
@property (nonatomic,strong) NSString *cardType;
@property (nonatomic,strong) NSString *cardHolder;
@property (nonatomic,strong) NSString *cvdApprovalCode;
@property (nonatomic,strong) NSString *cvdMessage;
@property (nonatomic) BOOL cardPressent;

- (id)initWithBinaryReader: (HpsBinaryDataScanner*)br;

@end
