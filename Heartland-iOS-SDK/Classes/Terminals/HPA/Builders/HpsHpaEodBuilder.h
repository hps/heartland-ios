

#import <Foundation/Foundation.h>
#import "HpsHpaDevice.h"



@interface HpsHpaEodBuilder : NSObject
{
    HpsHpaDevice *device;
}

@property (nonatomic, readwrite) int referenceNumber;

- (void) execute:(void(^)(HpsHpaEodResponse*, NSError*))responseBlock;
- (id)initWithDevice: (HpsHpaDevice*)HpaDevice;
@end


