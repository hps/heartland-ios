	//  Copyright (c) 2017 Heartland Payment Systems. All rights reserved.


#import <Foundation/Foundation.h>
#import "HpsConnectionConfig.h"
#import "HpsDeviceProtocols.h"

	// Block typedefs
@class HpsHeartSipTcpInterface;
typedef void (^ConnectionBlock)(HpsHeartSipTcpInterface*);
typedef void (^MessageBlock)(NSData*,NSString*);
typedef void (^SendReponseBlock)(NSData*, NSError*);

@interface HpsHeartSipTcpInterface : NSObject<IHPSDeviceCommInterface,NSStreamDelegate> {
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
@property (atomic,copy) MessageBlock messageReceivedBlock;
@property (atomic,copy) ConnectionBlock connectionOpenedBlock;
@property (atomic,copy) ConnectionBlock connectionFailedBlock;
@property (atomic,copy) ConnectionBlock connectionClosedBlock;
@property (atomic,copy) SendReponseBlock sendResponseBlock;

- (void)connect;
- (void)disconnect;
-(void) send:(id<IHPSDeviceMessage>)message andResponseBlock:(void(^)(NSData*, NSError*))responseBlock;
- (instancetype) initWithConfig:(HpsConnectionConfig*)config;

@end
