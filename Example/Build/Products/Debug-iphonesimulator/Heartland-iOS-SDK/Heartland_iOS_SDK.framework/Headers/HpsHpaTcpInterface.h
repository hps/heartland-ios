#import <Foundation/Foundation.h>
#import "HpsConnectionConfig.h"
#import "HpsDeviceProtocols.h"
#import "HpaEnums.h"

	// Block typedefs
@class HpsHpaTcpInterface;
typedef void (^HpaConnectionBlock)(HpsHpaTcpInterface*);
typedef void (^HpaMessageBlock)(NSData*,NSString*);
typedef void (^SendReponseBlock)(NSData*, NSError*);

@interface HpsHpaTcpInterface : NSObject<IHPSDeviceCommInterface,NSStreamDelegate> {
	NSInputStream* inputStream;
	NSMutableData* inputBuffer;
	BOOL isInputStreamOpen;

	NSOutputStream* outputStream;
	NSMutableData* outputBuffer;
	BOOL isOutputStreamOpen;

	HpaMessageBlock messageReceivedBlock;
	HpaConnectionBlock connectionOpenedBlock;
	HpaConnectionBlock connectionFailedBlock;
	HpaConnectionBlock connectionClosedBlock;
	NSString *messageRecived;
}
@property (nonatomic, strong) HpsConnectionConfig *config;
@property (atomic,copy) HpaMessageBlock messageReceivedBlock;
@property (atomic,copy) HpaConnectionBlock connectionOpenedBlock;
@property (atomic,copy) HpaConnectionBlock connectionFailedBlock;
@property (atomic,copy) HpaConnectionBlock connectionClosedBlock;
@property (atomic,copy) SendReponseBlock sendResponseBlock;

- (void)connect;
- (void)disconnect;
-(void) send:(id<IHPSDeviceMessage>)message andResponseBlock:(void(^)(NSData*, NSError*))responseBlock;
- (instancetype) initWithConfig:(HpsConnectionConfig*)config;

@end
