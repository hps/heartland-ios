#import "HpsDeviceMessage.h"
#import "HpsTerminalEnums.h"

@implementation HpsDeviceMessage

- (id) initWithBuffer:(NSData*)buffer{
    if((self = [super init]))
    {
        _buffer = [buffer copy];
    }
    return self;
}

-(NSData*) getSendBuffer{
    return [_buffer copy];
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
