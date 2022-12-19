#import "NSInputStream+Hps.h"

@implementation NSInputStream (Hps)

-(int)getLength{
	
	NSMutableData *mutableData = [[NSMutableData alloc]init];

	uint8_t length_buffer[2];
	NSInteger byteCount = [self read:length_buffer maxLength:sizeof(length_buffer)];
	if (byteCount != 2)
		return 0;

	[mutableData appendBytes:length_buffer length:sizeof(length_buffer)];
	NSString *dataDescription = mutableData.description;
	NSString *dataAsString = [dataDescription substringWithRange:NSMakeRange(1, [dataDescription length]-2)];
	unsigned intData = 0;
	NSScanner *scanner = [NSScanner scannerWithString:dataAsString];
	[scanner scanHexInt:&intData];

	return intData;
}

@end
