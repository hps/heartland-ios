#import <Foundation/Foundation.h>
#import "HpsPaxDeviceResponse.h"

@interface HpaPaxSafReportResponse : HpsPaxDeviceResponse

@property (nonatomic,strong) NSString *totalCount;
@property (nonatomic,strong) NSString *totalAmount;

- (id) initWithBuffer:(NSData*)buffer;
- (HpsBinaryDataScanner*) parseResponse;
@end
