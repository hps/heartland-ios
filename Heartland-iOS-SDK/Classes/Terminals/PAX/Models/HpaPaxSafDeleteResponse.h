#import <Foundation/Foundation.h>
#import "HpsPaxDeviceResponse.h"

@interface HpaPaxSafDeleteResponse : HpsPaxDeviceResponse

@property (nonatomic,strong) NSString *safDeletedCount;


- (id) initWithBuffer:(NSData*)buffer;
- (HpsBinaryDataScanner*) parseResponse;

@end

