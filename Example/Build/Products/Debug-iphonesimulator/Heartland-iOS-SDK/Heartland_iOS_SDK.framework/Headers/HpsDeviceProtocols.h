#import <Foundation/Foundation.h>
#import <GlobalMobileSDK/GlobalMobileSDK.h>

@protocol IHPSDeviceMessage
@required
-(NSData*) getSendBuffer;

- (id) initWithBuffer:(NSData*)buffer;
- (NSString*) toString;

@end

@protocol IHPSDeviceResponse

@required
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *command;
@property (nonatomic,strong) NSString *version;
@property (nonatomic,strong) NSString *deviceResponseCode;
@property (nonatomic,strong) NSString *deviceResponseMessage;
@optional
-(NSString*)toString;
@property (nonatomic) BOOL storedResponse;
@property (nonatomic,readwrite) int transactionId;
@property (nonatomic,readwrite) int lastResponseTransactionId;

@end

@protocol IHPSDeviceCommInterface
@required

-(void) connect;
-(void) disconnect;
-(void) send:(id<IHPSDeviceMessage>)message andResponseBlock:(void(^)(NSData*, NSError*))responseBlock;

//@optional
@end


@protocol IHPSRequestSubGroup
@required

-(NSString*) getElementString;

//@optional
@end
#pragma mark - HpaInterfaces
@protocol IInitializeResponse
@required
@property (nonatomic,strong) NSString *serialNumber;
@end

@protocol IDeviceInterface

- (void) cancel:(void(^)(NSError*))responseBlock;
- (void) closeLane:(void(^)(id <IInitializeResponse>, NSError*))responseBlock;
- (void) disableHostResponseBeep:(void(^)(id <IInitializeResponse>, NSError*))responseBlock;
- (void) initialize:(void(^)(id <IInitializeResponse>, NSError*))responseBlock;
- (void) openLane:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
- (void) reboot:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
- (void) reset:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
- (void) GetLastResponse:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;
- (void) setSAFMode:(BOOL)isSAF response:(void(^)(id <IHPSDeviceResponse>, NSError*))responseBlock;

@end

@interface HpsDeviceProtocols : NSObject

@end
