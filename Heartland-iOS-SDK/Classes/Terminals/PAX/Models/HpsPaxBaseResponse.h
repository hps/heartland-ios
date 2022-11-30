#import <Foundation/Foundation.h>
#import "HpsDeviceProtocols.h"
#import "HpsPaxMessageIDs.h"
#import "HpsTerminalEnums.h"
#import "HpsBinaryDataScanner.h"
#import "HpsPaxAmountResponse.h"
#import "HpsPaxAccountResponse.h"
#import "HpsPaxTraceResponse.h"
#import "HpsPaxAvsResponse.h"
#import "HpsPaxCommercialResponse.h"
#import "HpsPaxEcomSubGroup.h"
#import "HpsPaxExtDataSubGroup.h"
#import "HpsTerminalResponse.h"
#import "HpsPaxCashierSubGroup.h"
#import "HpsPaxCheckResponse.h"

@interface HpsPaxBaseResponse : HpsTerminalResponse <IHPSDeviceResponse>

//@property (nonatomic,strong) NSString *status;
//@property (nonatomic,strong) NSString *command;
//@property (nonatomic,strong) NSString *version;
//@property (nonatomic,strong) NSString *deviceResponseCode;
//@property (nonatomic,strong) NSString *deviceResponseMessage;
@property (nonatomic,strong) HpsPaxAmountResponse *amountResponse;
@property (nonatomic,strong) HpsPaxAccountResponse *accountResponse;
@property (nonatomic,strong) HpsPaxTraceResponse *traceResponse;
@property (nonatomic,strong) HpsPaxAvsResponse *avsResponse;
@property (nonatomic,strong) HpsPaxCommercialResponse *commercialResponse;
@property (nonatomic,strong) HpsPaxEcomSubGroup *ecomResponse;
@property (nonatomic,strong) HpsPaxExtDataSubGroup *extDataResponse;
@property (nonatomic,strong) HpsPaxCashierSubGroup *cashierResponse;
@property (nonatomic,strong) HpsPaxCheckResponse *checkResponse;


- (id) initWithMessageID:(NSString*)messageId andBuffer:(NSData*)buffer;
- (HpsBinaryDataScanner*) parseResponse;

@end
