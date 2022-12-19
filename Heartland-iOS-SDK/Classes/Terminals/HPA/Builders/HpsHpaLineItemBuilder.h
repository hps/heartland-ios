#import <Foundation/Foundation.h>
#import "HpsHpaDevice.h"

@interface HpsHpaLineItemBuilder : NSObject
{
	HpsHpaDevice *device;
}

@property (nonatomic, readwrite) int referenceNumber;
@property (nonatomic, strong) NSString *textLeft;
@property (nonatomic, strong) NSString *textRight;
@property (nonatomic, strong) NSString *r_textLeft;
@property (nonatomic, strong) NSString *r_textRight;

- (id) initWithDevice: (HpsHpaDevice*)HpaDevice;
- (void) execute:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;

@end

