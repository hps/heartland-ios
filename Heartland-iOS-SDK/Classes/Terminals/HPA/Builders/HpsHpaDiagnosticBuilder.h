
#import <Foundation/Foundation.h>
#import "HpsHpaDevice.h"

@interface HpsHpaDiagnosticBuilder : NSObject
{
    HpsHpaDevice *device;
}

@property (nonatomic, readwrite) int referenceNumber;

- (id) initWithDevice: (HpsHpaDevice*)HpaDevice;
- (void) execute:(void(^)(HpsHpaDiagnosticResponse*, NSError*))responseBlock;
@end


