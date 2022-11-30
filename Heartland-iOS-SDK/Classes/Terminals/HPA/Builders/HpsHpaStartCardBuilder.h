#import <Foundation/Foundation.h>
#import "HpsHpaDevice.h"

@interface HpsHpaStartCardBuilder : NSObject
{
	HpsHpaDevice *device;
}

@property (nonatomic, readwrite) NSString* cardGroup;
@property (nonatomic, readwrite) int referenceNumber;

- (id) initWithDevice: (HpsHpaDevice*)HpaDevice;
- (void) execute:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock ;

@end

