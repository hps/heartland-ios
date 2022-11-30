#import <Foundation/Foundation.h>
#import "HpsHpaDevice.h"



@interface HpsHpaSafBuilder : NSObject
{
	HpsHpaDevice *device;
}

@property (nonatomic, readwrite) int referenceNumber;

- (void) execute:(void(^)(HpsHpaSafResponse*, NSError*))responseBlock;
- (id)initWithDevice: (HpsHpaDevice*)HpaDevice;

@end
