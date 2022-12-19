#import "HpsPaxBaseResponse.h"
#import "HpsTerminalUtilities.h"

@interface HpsPaxBaseResponse()
{
	NSString *_messageId;
	NSData *_buffer;
	NSArray *_messageIds;
}

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSString *serviceURL;

@end

@implementation HpsPaxBaseResponse

- (id) initWithMessageID:(NSString*)messageId andBuffer:(NSData*)buffer{
	if((self = [super init]))
		{
		_buffer = [HpsTerminalUtilities trimHpsResponseData:buffer];
		_messageId = messageId;
		_messageIds = [NSArray arrayWithObjects:T09_RSP_DO_LOYALTY,_messageId, nil];

		}
	return self;
}

- (HpsBinaryDataScanner*) parseResponse{
	HpsBinaryDataScanner *binaryReader = [HpsBinaryDataScanner binaryDataScannerWithData:_buffer littleEndian:NO defaultEncoding:NSASCIIStringEncoding];

	self.status = [binaryReader readStringUntilDelimiter:HpsControlCodes_FS];
	self.command = [binaryReader readStringUntilDelimiter:HpsControlCodes_FS];
	self.version = [binaryReader readStringUntilDelimiter:HpsControlCodes_FS];
	self.deviceResponseCode = [binaryReader readStringUntilDelimiter:HpsControlCodes_FS];
	self.deviceResponseMessage = [binaryReader readStringUntilDelimiter:HpsControlCodes_FS];

	if (![_messageIds containsObject:self.command]) {
		@throw [NSException exceptionWithName:@"HpsScanException" reason:[NSString stringWithFormat:@"Unexpected message type received. Expected %@ but received %@.", _messageId, self.command] userInfo:nil];
	}

	NSLog(@"\r response_toString = %@ \r",[self toString]);
	return binaryReader;
}

- (NSString*) toString {

	NSMutableString *results = [NSMutableString string];
	const unsigned char *bytes = [_buffer bytes];
	for(int j=0; j< [_buffer length]; j++){

		if ([HpsTerminalEnums isControlCode:(Byte)bytes[j]]) {
			[results appendString:[NSString stringWithFormat:@"[%@]",[HpsTerminalEnums controlCodeAsciValue:bytes[j]]]];

		}else{
			[results appendString:[NSString stringWithFormat:@"%c",(unsigned char)bytes[j]]];

		}
	}

	return (NSString *)results;
}

@end
