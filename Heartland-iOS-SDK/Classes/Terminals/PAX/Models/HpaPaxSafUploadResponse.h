#import <Foundation/Foundation.h>
#import "HpsPaxDeviceResponse.h"

@interface HpaPaxSafUploadResponse : HpsPaxDeviceResponse

@property (nonatomic,strong) NSString *totalCount;
@property (nonatomic,strong) NSString *totalAmount;
@property (nonatomic,strong) NSString *timeStamp;
@property (nonatomic,strong) NSString *safUploadedCount;
@property (nonatomic,strong) NSString *safUploadedAmount;
@property (nonatomic,strong) NSString *safFailedCount;
@property (nonatomic,strong) NSString *safFailedTotal;

- (id) initWithBuffer:(NSData*)buffer;
- (HpsBinaryDataScanner*) parseResponse;
@end


