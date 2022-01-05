#import <Foundation/Foundation.h>
#import "HpsUpaResponse.h"
#import "HpsUpaDevice.h"

@interface HpsUpaVoidBuilder : NSObject
{
    HpsUpaDevice *device;
}

@property (nonatomic, readwrite) int referenceNumber;
@property (nonatomic, strong) NSString *ecrId;
@property (nonatomic, strong) NSString *clerkId;
@property (nonatomic, strong) NSString *terminalRefNumber;
@property (nonatomic, strong) NSString *issuerRefNumber;

- (void) execute:(void(^)(HpsUpaResponse*, NSError*))responseBlock;
- (id)initWithDevice: (HpsUpaDevice*)upaDevice;

@end
