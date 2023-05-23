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
@property (nonatomic,strong) NSString *transactionIdentifier DEPRECATED_MSG_ATTRIBUTE("Please, use cardBrandTransactionId instead");
@property (nonatomic,strong) NSString *gatewayTransactionId;
@property (nonatomic,strong) NSString *cardBrandTransactionId;

- (id)initWithBinaryReader: (HpsBinaryDataScanner*)br;

@end
