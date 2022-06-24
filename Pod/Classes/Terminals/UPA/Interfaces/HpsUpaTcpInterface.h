#import <Foundation/Foundation.h>
#import "HpsConnectionConfig.h"
#import "HpsDeviceProtocols.h"
#import "HpaEnums.h"
#import "JsonDoc.h"

    // Block typedefs
@class HpsUpaTcpInterface;
typedef void (^UpaConnectionBlock)(HpsUpaTcpInterface*);
typedef void (^UpaMessageBlock)(JsonDoc*,NSString*);
typedef void (^SendResponseBlock)(JsonDoc*, NSError*);

@interface HpsUpaTcpInterface : NSObject<IHPSDeviceCommInterface,NSStreamDelegate> {
    NSInputStream* inputStream;
    NSMutableData* inputBuffer;
    BOOL isInputStreamOpen;

    NSOutputStream* outputStream;
    NSMutableData* outputBuffer;
    BOOL isOutputStreamOpen;

    UpaMessageBlock messageReceivedBlock;
    UpaConnectionBlock connectionOpenedBlock;
    UpaConnectionBlock connectionFailedBlock;
    UpaConnectionBlock connectionClosedBlock;
    JsonDoc *messageReceived;
}
@property (nonatomic, strong) HpsConnectionConfig *config;
@property (atomic,copy) UpaMessageBlock messageReceivedBlock;
@property (atomic,copy) UpaConnectionBlock connectionOpenedBlock;
@property (atomic,copy) UpaConnectionBlock connectionFailedBlock;
@property (atomic,copy) UpaConnectionBlock connectionClosedBlock;
@property (atomic,copy) SendResponseBlock sendResponseBlock;

- (void)connect;
- (void)disconnect;
-(void) send:(id<IHPSDeviceMessage>)message andResponseBlock:(void(^)(JsonDoc*, NSError*))responseBlock;
- (instancetype) initWithConfig:(HpsConnectionConfig*)config;

@end
