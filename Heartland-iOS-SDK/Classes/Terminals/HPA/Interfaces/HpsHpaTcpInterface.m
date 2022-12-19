#import "HpsHpaTcpInterface.h"
#import "HpsHpaDevice.h"
#import "HpsCommon.h"
#import "HpsterminalUtilities.h"
#import "NSObject+ObjectMap.h"
#import "NSInputStream+Hps.h"
#define BUF_SIZE 10240

#pragma mark - Private properties and methods

@interface HpsHpaTcpInterface () {
	NSString *errorDomain;
	NSString *filepath;
	int fileNumber;
	BOOL isHalfResponse;
}

- (BOOL)openConnection;
- (void)closeConnection;
- (BOOL)isConnected;
- (void)finishOpeningConnection;
- (void)readFromStreamToInputBuffer;
- (void)parseIncomingData;
- (void)writeOutputBufferToStream;
- (void)notifyConnectionBlock:(HpaConnectionBlock)block;

@end


@implementation HpsHpaTcpInterface

@synthesize messageReceivedBlock;
@synthesize connectionOpenedBlock, connectionFailedBlock, connectionClosedBlock;
@synthesize sendResponseBlock;

#pragma mark - Initializer

- (instancetype) initWithConfig:(HpsConnectionConfig*)config
{
	if((self = [super init]))
		{
		_config = config;
		errorDomain = [HpsCommon sharedInstance].hpsErrorDomain;
		}
	return self;
}

#pragma mark - IHPSDeviceCommInterface Required Methods

- (void)connect {
	if (![self isConnected]) {
		if (![self openConnection]) {
			[self notifyConnectionBlock:connectionFailedBlock];
		}
	}
}

- (void)disconnect {
	[self closeConnection];
}


-(void) send:(id<IHPSDeviceMessage>)message andResponseBlock:(void(^)(NSData*, NSError*))responseBlock
{
	[self openConnection];

	NSLog(@"request_toString = %@",message.toString);

	self.sendResponseBlock = responseBlock;
	[self addCallBackBlocks];
	[self connectionOpenBlock:message];

}

#pragma mark CallBack Methods

-(void) connectionOpenBlock:(id<IHPSDeviceMessage>)message{
		//Connection_open_block_start

	__weak typeof(self) weakSelf = self;
	__weak typeof(outputBuffer) weakOutputBuffer = outputBuffer;
	self.connectionOpenedBlock = ^(HpsHpaTcpInterface* connection){

		if([weakSelf isConnected]){

			NSData *data = [message getSendBuffer];
			[weakOutputBuffer appendBytes:data.bytes length:data.length];
			[weakSelf writeOutputBufferToStream];
		};
			// Connection_open_block_end
	};
}

-(void) messagesRecivedBlock{
		// Message_Recieve_block_start

	__weak typeof(self) weakSelf = self;
	__weak typeof(errorDomain) weakErrorDomain = errorDomain;

	self.messageReceivedBlock = ^(NSData* hpaObject, NSString* error){

		if (hpaObject){

			dispatch_async(dispatch_get_main_queue(), ^{
				NSLog(@"Step 3 without Error");

				weakSelf.sendResponseBlock(hpaObject, nil);
				[weakSelf closeConnection];

			});

		}
		else{

			dispatch_async(dispatch_get_main_queue(), ^{

				NSDictionary *userInfo = @{NSLocalizedDescriptionKey:error};

				NSError *error = [NSError errorWithDomain:weakErrorDomain
													 code:CocoaError
												 userInfo:userInfo];
				NSLog(@"Step 3 with Error");

				weakSelf.sendResponseBlock(nil, error);
			});
		}
	};

		// Message_Recieve_block_end
}

-(void)connectionsClosedBlock{


		// Connection_Close_block_start

	self.connectionClosedBlock = ^(HpsHpaTcpInterface* connection){
		NSLog(@"connection closed");
	};
		// Connection_Close_block_end

}

-(void)connectionsFailedBlock
{
	__weak typeof(self) weakSelf = self;
	__weak typeof(errorDomain) weakErrorDomain = errorDomain;
		// Connection_Failed_Block_Start

	weakSelf.connectionFailedBlock = ^(HpsHpaTcpInterface* connection){
		dispatch_async(dispatch_get_main_queue(), ^{

			NSDictionary *userInfo = @{NSLocalizedDescriptionKey:@"Connection Failed"};

			NSError *error = [NSError errorWithDomain:weakErrorDomain
												 code:CocoaError
											 userInfo:userInfo];

			weakSelf.sendResponseBlock(nil, error);

		});
	};

		// Connection_Failed_Block_end

}
-(void) addCallBackBlocks
{
	[self connectionsClosedBlock];
	[self connectionsFailedBlock];
	[self messagesRecivedBlock];
}

#pragma mark - Private methods

- (BOOL)openConnection {
	isInputStreamOpen = NO;
	isOutputStreamOpen = NO;

	CFReadStreamRef readStream;
	CFWriteStreamRef writeStream;

	CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
									   (__bridge CFStringRef)self.config.ipAddress, self.config.port.intValue,
									   &readStream, &writeStream);

	if (readStream == nil || writeStream == nil)
		return NO;

	CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket,
							kCFBooleanTrue);
	CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket,
							 kCFBooleanTrue);

	inputStream = (__bridge_transfer NSInputStream*)readStream;
	inputStream.delegate = self;
	[inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[inputStream open];

	outputStream = (__bridge_transfer NSOutputStream*)writeStream;
	outputStream.delegate = self;
	[outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[outputStream open];

	inputBuffer = [[NSMutableData alloc] init];
	outputBuffer = [[NSMutableData alloc] init];

	return YES;
}

- (void)closeConnection {

	if (![self isConnected])
		[self notifyConnectionBlock:connectionFailedBlock];
	else
		[self notifyConnectionBlock:connectionClosedBlock];

	inputStream.delegate = nil;
	[inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[inputStream close];
	inputStream = nil;
	isInputStreamOpen = NO;

	outputStream.delegate = nil;
	[outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[outputStream close];
	outputStream = nil;
	isOutputStreamOpen = NO;

	inputBuffer = nil;
	outputBuffer = nil;
}

- (BOOL)isConnected {
	return (isInputStreamOpen && isOutputStreamOpen);
}

- (void)finishOpeningConnection {
	if (isInputStreamOpen && isOutputStreamOpen) {
		[self notifyConnectionBlock:connectionOpenedBlock];
		[self writeOutputBufferToStream];
	}
}

- (void)readFromStreamToInputBuffer {

	@try {
		[self getFullResponse:^(NSMutableData *response,NSInteger msgLength) {
			if (response){
				[self->inputBuffer appendBytes:[response bytes] length:msgLength];
				[self parseIncomingData];
			}
		}];

	} @catch (NSException *exception) {
		[self closeConnection];
		@throw exception;
	}
}

-(void)getFullResponse:(void(^)(NSMutableData *response,NSInteger msgLength))responseBlock{
	@synchronized (self) {
		NSMutableData *responseMutableData = [NSMutableData new];
		NSInteger response_length =  [inputStream getLength];
		uint8_t buffer[response_length];

		NSInteger bytesReadlength = 0;
		NSInteger bytesReadlengthActual = 0;
		if ([inputStream hasBytesAvailable])
			{
			BOOL incomplete =  true;
			fileNumber = fileNumber +1;
			NSLog(@"Total length= %ld",(long)response_length);

			do{
				memset(buffer, 0, sizeof(buffer));
				NSInteger temp_length =  response_length;
				bytesReadlengthActual = [inputStream read:buffer maxLength:sizeof(buffer)];
				bytesReadlength += bytesReadlengthActual;

				if (temp_length != bytesReadlength) {
					incomplete = true;
					isHalfResponse = YES;
					temp_length = (temp_length - bytesReadlength);
						//	NSLog(@"*** first half length= %ld",(long)bytesReadlength);
					[responseMutableData appendBytes:buffer length:bytesReadlengthActual];

				}
				else{
					if (isHalfResponse) {
							//NSLog(@"*** second half length = %ld",(long)bytesReadlength);
						[responseMutableData appendBytes:buffer length:response_length];

						isHalfResponse = NO;
					}else
						{
						[responseMutableData appendBytes:buffer length:response_length];
						}

					incomplete = false;
						//NSLog(@"***full = %ld",(long)bytesReadlength);

						//NSLog(@"Toatal Response size = %ld",(long)sizeof(response_buffer));
				}
			}while(incomplete);

			responseBlock(responseMutableData,response_length);
			}
	}

}



- (void)parseIncomingData {

	@try {
		if ([inputBuffer length] > 0 ){

			if ([inputBuffer length] > 0) {


				HpsHpaResponse *responseToCheckMultiMessage = [[HpsHpaResponse alloc]initWithXMLData:inputBuffer];
                
                if ([responseToCheckMultiMessage.Response isEqualToString: HPA_MSG_ID_toString[NOTIFICATION]])
                {
                    NSLog(@"\n\n Discard Notification response...\n");
                }
				else if (responseToCheckMultiMessage.MultipleMessage.integerValue == 0)
					{
					NSString* bufferString = [[NSString alloc] initWithBytesNoCopy:[inputBuffer mutableBytes]
																			length:[inputBuffer length]
																		  encoding:NSASCIIStringEncoding
																	  freeWhenDone:NO];
					messageRecived = bufferString;

					NSLog(@"\n\n **** No MultiMessage ...\n\n");
						//NSLog(@"TCP response FINAL = %@",[[NSString alloc]initWithData:inputBuffer encoding:NSASCIIStringEncoding] );

					if (messageReceivedBlock != nil)
						messageReceivedBlock(messageRecived.XMLData,nil);

					[inputBuffer replaceBytesInRange:NSMakeRange(0,inputBuffer.length)
										   withBytes:NULL
											  length:0];
					}
				else{
					NSLog(@"\n****Getting MultiMessage ... %lu",(unsigned long)[inputBuffer length]);
						//NSLog(@"TCP response half FINAL = %@",[[NSString alloc]initWithData:inputBuffer encoding:NSASCIIStringEncoding] );
						//	NSLog(@"### %@",responseToCheckMultiMessage);
				}
			}
		}

	} @catch (NSException *exception) {
		@throw exception;
	}

}

- (void)writeOutputBufferToStream {
	if (![self isConnected])
		return;

	if ([outputBuffer length] == 0)
		return;

	if (![outputStream hasSpaceAvailable])
		return;

	NSInteger bytesWritten = [outputStream write:[outputBuffer bytes]
									   maxLength:[outputBuffer length]];

	if (bytesWritten == -1)  {
		[self disconnect];
		return;
	}

	[outputBuffer replaceBytesInRange:NSMakeRange(0, bytesWritten)
							withBytes:NULL
							   length:0];
}

- (void)notifyConnectionBlock:(HpaConnectionBlock)block {
	if (block != nil)
		block(self);
}

#pragma mark - NSStreamDelegate methods

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)streamEvent {

	if (stream == inputStream) {
		switch (streamEvent) {

			case NSStreamEventOpenCompleted:
				isInputStreamOpen = YES;
				[self finishOpeningConnection];
				break;

			case NSStreamEventHasBytesAvailable:
				@try {
					[self readFromStreamToInputBuffer];

				} @catch (NSException *exception) {
						//NSLog(@"stream = %@",exception);
					NSDictionary *userInfo = @{NSLocalizedDescriptionKey:exception.description};

					NSError *error = [NSError errorWithDomain:errorDomain
														 code:CocoaError
													 userInfo:userInfo];

					self.sendResponseBlock(nil, error);
				}
				break;

			case NSStreamEventHasSpaceAvailable:
				NSLog(@"#### SPACE AVAILABLE");
				break;

			case NSStreamEventErrorOccurred:

				[self closeConnection];

				break;
			case NSStreamEventEndEncountered:
				NSLog(@"#### End of Stream has been reached so now closing connection");

				if (messageReceivedBlock != nil)
					messageReceivedBlock(messageRecived.XMLData,nil);
					//self.sendResponseBlock([server_message dataUsingEncoding:NSUTF8StringEncoding], nil);

					//[self closeConnection];x
				break;
			default:
				NSLog(@"Unknown Event Generated = %lu", (unsigned long)streamEvent);
				break;
		}
	}

	if (stream == outputStream) {
		switch (streamEvent) {

			case NSStreamEventOpenCompleted:
				isOutputStreamOpen = YES;
				[self finishOpeningConnection];
				break;

			case NSStreamEventHasBytesAvailable:
				break;

			case NSStreamEventHasSpaceAvailable:
				[self writeOutputBufferToStream];
				break;

			case NSStreamEventErrorOccurred:
				messageReceivedBlock(nil,@" Error Occured -> OutputStream");
				break;
			case NSStreamEventEndEncountered:
				[self closeConnection];
				break;
			default:
				NSLog(@"Unknown Event Generated = %lu", (unsigned long)streamEvent);
				break;
		}
	}
}

@end
