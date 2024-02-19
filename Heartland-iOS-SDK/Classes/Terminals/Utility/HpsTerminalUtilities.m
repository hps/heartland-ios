#import "HpsTerminalUtilities.h"
#import "HpsTerminalEnums.h"

@implementation HpsTerminalUtilities

+ (HpsDeviceMessage*) buildRequest: (NSString*) messageId{
    return [self buildMessage:messageId withMessage:@""];
    
}

+ (HpsDeviceMessage*) buildRequest: (NSString*) messageId withElements:(NSArray*)elements{
    NSString *message = [self getElementString:elements];
    return [self buildMessage:messageId withMessage:message];
}

+ (NSString*) getElementString:(NSArray*)elements{
	NSMutableString *sb = [[NSMutableString alloc] init];
	for (int i = 0; i < elements.count; i++) {

		id thing = elements[i];

		if ([thing isKindOfClass:[NSArray class]]) {
			for (NSString *thisString in thing) {
				[sb appendString:[NSString stringWithFormat:@"%c",HpsControlCodes_FS]];
				[sb appendString:thisString];
			}
		}else if ([HpsTerminalEnums isControlCode:(Byte)thing]){
			NSString *codestring = [HpsTerminalEnums controlCodeString:(Byte)thing];
			[sb appendString:codestring];
		}else if ([thing respondsToSelector:@selector(getElementString)]) {
			NSString *valueRecived = [thing performSelector:@selector(getElementString)];
			NSString *modifiedString = [self trimHpsRequestString:valueRecived];
			[sb appendString:modifiedString];
		}else if ([thing isKindOfClass:[NSString class]]) {
			[sb appendString:thing];
		}

	}
	return [sb copy];
}

+ (HpsDeviceMessage*) buildMessage: (NSString*) messageId withMessage:(NSString*)message{

    NSMutableData *buffer = [[NSMutableData alloc] init];
    
    //Begin Message    
    [buffer appendBytes:(char []){ HpsControlCodes_STX } length:1];
    
    //Add MessageID
    [buffer appendData:[messageId dataUsingEncoding:NSASCIIStringEncoding]];
    [buffer appendBytes:(char []){ HpsControlCodes_FS } length:1];
    
    //Add Version
    [buffer appendData:[PAX_DEVICE_VERSION dataUsingEncoding:NSASCIIStringEncoding]];
    if (messageId != A14_CANCEL) {
        [buffer appendBytes:(char []){ HpsControlCodes_FS }  length:1];
    }
    
    // Add the Message
    [buffer appendData:[message dataUsingEncoding:NSASCIIStringEncoding]];
    
    //End Message
    [buffer appendBytes:(char []){ HpsControlCodes_ETX }  length:1];    
        
    //Calc LRC
    Byte lrc = [self calcLRC:buffer];
    [buffer appendBytes:(char []){ lrc } length:sizeof(lrc)];
    
    //Return
    return [[HpsDeviceMessage alloc] initWithBuffer:buffer];
    
}

+ (Byte) calcLRC:(NSMutableData*) data{
    Byte LRC = 0;
    
    const unsigned char *bytes = [data bytes];
    for(int j=1; j < [data length]; j++){
       LRC ^= bytes[j];
    }    
    return LRC;
}

+ (NSString *)trimHpsRequestString:(NSString *)message{
	NSData* data = [message dataUsingEncoding:NSUTF8StringEncoding];
	NSMutableData *mutable_data = [[NSMutableData alloc]initWithData:data];;

	unsigned char *bytes = (unsigned char *)[mutable_data bytes];
	int length = [NSNumber numberWithInteger:[mutable_data length]].intValue;
	BOOL isTrimmed = NO;

	for(int j=length-1; j >= 0 && !isTrimmed; j--){
		Byte currentByte = (Byte)bytes[j];

		switch (currentByte) {
			case HpsControlCodes_US:
				[mutable_data setLength:mutable_data.length - sizeof(Byte)];
				break;
			case HpsControlCodes_FS:
				break;
			default:
				isTrimmed = YES;
				break;
		}
	}

 NSString *trimmed_US_CodeAtEnd	=  [[NSString alloc]initWithData:mutable_data encoding:NSUTF8StringEncoding];
	return trimmed_US_CodeAtEnd;
}

+ (NSData *)trimHpsResponseData:(NSData *)data{
	NSString *responseString = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
	NSArray *array	= [responseString componentsSeparatedByString:[HpsTerminalEnums controlCodeString:HpsControlCodes_FS]];
	NSMutableString *trimmedString = [[NSMutableString alloc] init];
	for (int i = 0 ; i < [array count];i++){
		[trimmedString appendString:[self trimHpsRequestString:[array objectAtIndex:i]]];
		if (!(i == [array count] -1))
			[trimmedString appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_FS]];
	}

return [trimmedString dataUsingEncoding:NSUTF8StringEncoding];
}


	//HPA
+ (id <IHPSDeviceMessage>) BuildRequest:(NSString *) message withFormat:(MessageFormat)format {
	NSMutableData *buffer = [[NSMutableData alloc] init];

	switch(format)
	{
		case Visa2nd:
		{
			[buffer appendBytes:(char []){ HpsControlCodes_STX } length:1];
			[buffer appendData:[message dataUsingEncoding:NSASCIIStringEncoding]];
			[buffer appendBytes:(char []){ HpsControlCodes_ETX }  length:1];
			Byte lrc = [HpsTerminalUtilities calcLRC:buffer];
			[buffer appendBytes:(char []){ lrc } length:sizeof(lrc)];
		}
		break;

		case HPA:
		{
			//add length
		uint16_t swapped = NSSwapHostShortToBig(message.length);
		[buffer appendBytes:&swapped length:sizeof(swapped)];
		//Add Message
		[buffer appendData:[message dataUsingEncoding:NSASCIIStringEncoding]];
}
		break;
        
        case UPA: {
            [buffer appendBytes:(char []){ HpsControlCodes_STX } length:1];
            [buffer appendBytes:(char []){ HpsControlCodes_LF } length:1];
            [buffer appendData:[message dataUsingEncoding:NSASCIIStringEncoding]];
            [buffer appendBytes:(char []){ HpsControlCodes_LF } length:1];
            [buffer appendBytes:(char []){ HpsControlCodes_ETX } length:1];
            [buffer appendBytes:(char []){ HpsControlCodes_LF } length:1];
            
            break;
        }
		default:

		break;
			
	}
		//Return
	
	return [[HpsDeviceMessage alloc] initWithBuffer:buffer];
}

@end
