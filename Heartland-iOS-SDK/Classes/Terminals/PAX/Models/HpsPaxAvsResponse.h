#import <Foundation/Foundation.h>
#import "HpsBinaryDataScanner.h"
#import "HpsTerminalEnums.h"

@interface HpsPaxAvsResponse : NSObject

@property (nonatomic,strong) NSString *avsResponseCode;
@property (nonatomic,strong) NSString *avsResponseMessage;

- (id)initWithBinaryReader: (HpsBinaryDataScanner*)br;

@end
