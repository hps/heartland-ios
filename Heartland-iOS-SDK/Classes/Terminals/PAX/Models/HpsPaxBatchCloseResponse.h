#import <Foundation/Foundation.h>
#import "HpsPaxDeviceResponse.h"

@interface HpsPaxBatchCloseResponse : HpsPaxDeviceResponse

@property (nonatomic,strong) NSString *totalCount;
@property (nonatomic,strong) NSString *totalAmount;
@property (nonatomic,strong) NSString *timeStamp;
@property (nonatomic,strong) NSString *tid;
@property (nonatomic,strong) NSString *mid;

- (id) initWithBuffer:(NSData*)buffer;
- (HpsBinaryDataScanner*) parseResponse;

@end
