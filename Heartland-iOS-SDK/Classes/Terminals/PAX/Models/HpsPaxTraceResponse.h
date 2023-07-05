#import <Foundation/Foundation.h>
#import "HpsBinaryDataScanner.h"
#import "HpsTerminalEnums.h"

@interface HpsPaxTraceResponse : NSObject

@property (nonatomic,strong) NSString *referenceNumber;
@property (nonatomic,strong) NSString *transactionNunmber;
@property (nonatomic,strong) NSString *timeStamp;
@property (nonatomic,strong) NSString *ecrRefNumber;
 
- (id)initWithBinaryReader: (HpsBinaryDataScanner*)br;

@end
