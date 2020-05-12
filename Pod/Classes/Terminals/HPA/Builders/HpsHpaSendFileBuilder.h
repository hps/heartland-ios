#import <Foundation/Foundation.h>
#import "HpsHpaDevice.h"

@interface HpsHpaSendFileBuilder : NSObject
{
    HpsHpaDevice *device;
}
@property (nonatomic, readwrite) int referenceNumber;
@property (nonatomic, strong) NSString* multipleMessage;
@property (nonatomic, strong) NSString* filePath;

- (id) initWithDevice: (HpsHpaDevice*)HpaDevice;
- (void) executeSendFileNameRequest:(void(^)(id<IHPSDeviceResponse>, NSError*))responseBlock ;
- (void) executeSendFileDataRequest:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock ;
@end

