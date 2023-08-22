#import <Foundation/Foundation.h>
#import "HpsUpaResponse.h"
#import "HpsUpaDevice.h"

#import "HpsCreditCard.h"
#import "HpsAddress.h"
#import "HpsEnums.h"

@interface HpsUpaVerifyBuilder : NSObject
{
    HpsUpaDevice *device;
}

@property (nonatomic, readwrite) int referenceNumber;
@property (nonatomic, readwrite) BOOL requestMultiUseToken;
@property (nonatomic, strong) NSString* clerkId;
@property (nonatomic, strong) NSString* ecrId;
@property (nonatomic, strong) NSString* token;
@property (nonatomic, readwrite) HpsStoredCardInitiator storedCardInitiator;
@property (nonatomic, strong) NSString *cardBrandTransactionId;

- (void) execute:(void(^)(HpsUpaResponse*, NSError*))responseBlock;
- (id)initWithDevice: (HpsUpaDevice*)upaDevice;

 
@end
