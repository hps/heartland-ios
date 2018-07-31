#import <Foundation/Foundation.h>
#import "HpsPaxDeviceResponse.h"

@interface HpsPaxInitializeResponse : HpsPaxDeviceResponse

@property (nonatomic,strong) NSString *serialNumber;

- (id) initWithBuffer:(NSData*)buffer;
- (HpsBinaryDataScanner*) parseResponse;

@end
