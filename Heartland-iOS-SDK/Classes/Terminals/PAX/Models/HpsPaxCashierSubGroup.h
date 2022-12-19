#import <Foundation/Foundation.h>
#import "HpsBinaryDataScanner.h"
#import "HpsTerminalEnums.h"
#import "HpsDeviceProtocols.h"

@interface HpsPaxCashierSubGroup : NSObject <IHPSRequestSubGroup>

@property (nonatomic, strong) NSString* clerkId;
@property (nonatomic, strong) NSString* shiftId;

- (NSString*) getElementString;
- (id)initWithBinaryReader: (HpsBinaryDataScanner*)br;

@end
