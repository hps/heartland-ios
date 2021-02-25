#import <Foundation/Foundation.h>
#import "HpsPaxBaseResponse.h"
#import "HpsPaxHostResponse.h"
#import "HpsPaxAmountResponse.h"
#import "HpsPaxAccountResponse.h"
#import "HpsPaxTraceResponse.h"
#import "HpsPaxAvsResponse.h"
#import "HpsPaxCommercialResponse.h"
#import "HpsPaxEcomSubGroup.h"
#import "HpsPaxExtDataSubGroup.h"

@interface HpsPaxDeviceResponse : HpsPaxBaseResponse

@property (nonatomic,strong) NSString *responseCode;
@property (nonatomic,strong) NSString *referenceNumber;
@property (nonatomic,strong) NSString *pinEntryStatus;
@property (nonatomic,strong) NSString *printLine1;
@property (nonatomic,strong) NSString *printLine2;
@property (nonatomic,strong) NSString *printLine3;
@property (nonatomic,strong) NSString *printLine4;
@property (nonatomic,strong) NSString *printLine5;

- (id) initWithMessageID:(NSString*)messageId andBuffer:(NSData*)buffer;
- (HpsBinaryDataScanner*) parseResponse;
- (void) mapResponse;

@end
