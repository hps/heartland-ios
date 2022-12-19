#import <Foundation/Foundation.h>
#import "HpsHpaDevice.h"

@interface HpsHpaDownloadBuilder : NSObject
{
	HpsHpaDevice *device;
}

@property (nonatomic, readwrite) NSString* url;
@property (nonatomic, readwrite) NSString* downloadType;
@property (nonatomic, readwrite) NSString* downloadTime;
@property (nonatomic, readwrite) NSString* terminalId;
@property (nonatomic, readwrite) NSString* applicationId;
@property (nonatomic, readwrite) int referenceNumber;

- (id) initWithDevice: (HpsHpaDevice*)HpaDevice;
- (void) execute:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;

@end

