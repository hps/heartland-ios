#import <Foundation/Foundation.h>
#import "HpsBinaryDataScanner.h"
#import "HpsTerminalEnums.h"
#import "HpsDeviceProtocols.h"

@interface HpsPaxExtDataSubGroup : NSObject <IHPSRequestSubGroup>

@property (nonatomic,strong) NSMutableDictionary *collection;

- (id)initWithBinaryReader: (HpsBinaryDataScanner*)br;
- (NSString*) getElementString;

@end
