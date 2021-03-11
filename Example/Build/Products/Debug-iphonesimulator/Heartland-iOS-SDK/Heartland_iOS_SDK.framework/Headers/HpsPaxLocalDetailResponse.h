#import <Foundation/Foundation.h>
#import "HpsPaxDeviceResponse.h"

@interface HpsPaxLocalDetailResponse : HpsPaxDeviceResponse

@property (nonatomic,strong) NSString *authorizationCode;
@property (nonatomic,strong) NSString *totalRecord;
@property (nonatomic,strong) NSString *recordNumber;
@property (nonatomic,strong) NSString *edcType;
@property (nonatomic,strong) NSString *originalTransactionType;

- (id) initWithBuffer:(NSData*)buffer;
- (HpsBinaryDataScanner*) parseResponse;
- (void) mapResponse;


@end


