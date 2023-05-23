#import <Foundation/Foundation.h>
#import "HpsPaxDeviceResponse.h"

@interface HpsPaxCreditResponse : HpsPaxDeviceResponse

@property (nonatomic,strong) NSString *authorizationCode;
@property (nonatomic,strong) NSString *cardBrandTransactionId;

- (id) initWithBuffer:(NSData*)buffer;
- (HpsBinaryDataScanner*) parseResponse;
- (void) mapResponse;

@end
