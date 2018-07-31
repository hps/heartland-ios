#import <Foundation/Foundation.h>
#import "HpsConnectionConfig.h"
#import "HpsDeviceProtocols.h"

// Block typedefs
@class HpsPaxTcpInterface;

typedef void (^ConnectionBlock)(HpsPaxTcpInterface*);
typedef void (^MessageBlock)(HpsPaxTcpInterface*,NSString*);
typedef void (^SendReponseBlock)(NSData*, NSError*);

@interface HpsPaxTcpInterface : NSObject<IHPSDeviceCommInterface,NSStreamDelegate> {
  NSInputStream* inputStream;
  NSMutableData* inputBuffer;
  BOOL isInputStreamOpen;
  
   NSOutputStream* outputStream;
  NSMutableData* outputBuffer;
  BOOL isOutputStreamOpen;
  
  MessageBlock messageReceivedBlock;
  ConnectionBlock connectionOpenedBlock;
  ConnectionBlock connectionFailedBlock;
  ConnectionBlock connectionClosedBlock;
	NSString *messageRecived;
}
@property (nonatomic, strong) HpsConnectionConfig *config;

- (void)connect;
- (void)disconnect;
-(void) send:(id<IHPSDeviceMessage>)message andResponseBlock:(void(^)(NSData*, NSError*))responseBlock;

- (instancetype) initWithConfig:(HpsConnectionConfig*)config;

@property (copy) MessageBlock messageReceivedBlock;
@property (copy) ConnectionBlock connectionOpenedBlock;
@property (copy) ConnectionBlock connectionFailedBlock;
@property (copy) ConnectionBlock connectionClosedBlock;
@property (copy) SendReponseBlock sendResponseBlock;

@end
