#import <Foundation/Foundation.h>
#import "HpsBinaryDataScanner.h"
#import "HpsTerminalEnums.h"

@interface HpsPaxHostResponse : NSObject

@property (nonatomic,strong) NSString *hostResponseCode;
@property (nonatomic,strong) NSString *hostResponseMessage;
@property (nonatomic,strong) NSString *authCode;
@property (nonatomic,strong) NSString *hostReferenceNumber;
@property (nonatomic,strong) NSString *traceNumber;
@property (nonatomic,strong) NSString *batchNumber;

- (id)initWithBinaryReader: (HpsBinaryDataScanner*)br;

@end
