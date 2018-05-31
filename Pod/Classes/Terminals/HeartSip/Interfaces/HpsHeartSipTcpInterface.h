	//  Copyright (c) 2017 Heartland Payment Systems. All rights reserved.


#import <Foundation/Foundation.h>
#import "HpsConnectionConfig.h"
#import "HpsDeviceProtocols.h"

	// Block typedefs
@class HpsHeartSipTcpInterface;
typedef void (^HPAConnectionBlock)(HpsHeartSipTcpInterface*);
typedef void (^HPAMessageBlock)(NSData*,NSString*);
typedef void (^SendReponseBlock)(NSData*, NSError*);

@interface HpsHeartSipTcpInterface : NSObject<IHPSDeviceCommInterface,NSStreamDelegate> {
	NSInputStream* inputStream;
	NSMutableData* inputBuffer;
	BOOL isInputStreamOpen;

	NSOutputStream* outputStream;
	NSMutableData* outputBuffer;
	BOOL isOutputStreamOpen;

	HPAMessageBlock messageReceivedBlock;
	HPAConnectionBlock connectionOpenedBlock;
	HPAConnectionBlock connectionFailedBlock;
	HPAConnectionBlock connectionClosedBlock;
	NSString *messageRecived;
}
@property (nonatomic, strong) HpsConnectionConfig *config;
@property (atomic,copy) HPAMessageBlock messageReceivedBlock;
@property (atomic,copy) HPAConnectionBlock connectionOpenedBlock;
@property (atomic,copy) HPAConnectionBlock connectionFailedBlock;
@property (atomic,copy) HPAConnectionBlock connectionClosedBlock;
@property (atomic,copy) SendReponseBlock sendResponseBlock;

- (void)connect;
- (void)disconnect;
-(void) send:(id<IHPSDeviceMessage>)message andResponseBlock:(void(^)(NSData*, NSError*))responseBlock;
- (instancetype) initWithConfig:(HpsConnectionConfig*)config;

@end
