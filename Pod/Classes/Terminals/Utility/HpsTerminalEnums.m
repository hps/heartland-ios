#import "HpsTerminalEnums.h"

@implementation HpsTerminalEnums

NSString *const PAX_DEVICE_VERSION = @"1.35";

+ (BOOL) isControlCode:(Byte)code{
    BOOL isControlCode = NO;
     
    switch (code) {
        case HpsControlCodes_STX:
            isControlCode = YES;
            break;
        case HpsControlCodes_ETX:
            isControlCode = YES;
            break;
        case HpsControlCodes_ACK:
            isControlCode = YES;
            break;
        case HpsControlCodes_NAK:
            isControlCode = YES;
            break;
        case HpsControlCodes_ENQ:
            isControlCode = YES;
            break;
        case HpsControlCodes_FS:
            isControlCode = YES;
            break;
        case HpsControlCodes_GS:
            isControlCode = YES;
            break;            
        case HpsControlCodes_EOT:
            isControlCode = YES;
            break;
        case HpsControlCodes_US:
            isControlCode = YES;
            break;
        case HpsControlCodes_RS:
            isControlCode = YES;
            break;
        case HpsControlCodes_COMMA:
            isControlCode = YES;
            break;
        case HpsControlCodes_COLON:
            isControlCode = YES;
            break;
        case HpsControlCodes_PTGS:
            isControlCode = YES;
            break;
        default:
            break;
    }
    
    return isControlCode;
    
}
+ (NSString*) controlCodeString:(Byte)code{
    NSData *code_d = [[NSData alloc] initWithBytes:(char []){ code } length:1];
    return [[NSString alloc] initWithData:code_d encoding:NSUTF8StringEncoding];
}

+ (NSString *) controlCodeAsciValue:(Byte)code{
	NSString *ASCIIValue = @"";

	switch (code) {
		case HpsControlCodes_STX:
			ASCIIValue = @"STX";
			break;
		case HpsControlCodes_ETX:
			ASCIIValue = @"ETX";
			break;
		case HpsControlCodes_ACK:
			ASCIIValue = @"ACK";
			break;
		case HpsControlCodes_NAK:
			ASCIIValue = @"NAK";
			break;
		case HpsControlCodes_ENQ:
			ASCIIValue = @"ENQ";
			break;
		case HpsControlCodes_FS:
			ASCIIValue = @"FS";
			break;
		case HpsControlCodes_GS:
			ASCIIValue = @"GS";
			break;
		case HpsControlCodes_EOT:
			ASCIIValue = @"EOT";
			break;
		case HpsControlCodes_US:
			ASCIIValue = @"US";
			break;
		case HpsControlCodes_RS:
			ASCIIValue = @"RS";
			break;
		case HpsControlCodes_COMMA:
			ASCIIValue = @"COMMA";
			break;
		case HpsControlCodes_COLON:
			ASCIIValue = @"COLON";
			break;
		case HpsControlCodes_PTGS:
			ASCIIValue = @"PTGS";
			break;
		default:
			break;
	}

	return ASCIIValue;
	
}

+ (NSString*)entryModeToString:(HpsPaxEntryModes)entryMode
{
	switch(entryMode) {
		case HpsPaxEntryModes_Manual:
			return @"Manual";
		case HpsPaxEntryModes_Swipe:
			return @"Swipe";
		case HpsPaxEntryModes_Contactless:
			return @"Contactless";
		case HpsPaxEntryModes_Scanner:
			return @"Scanner";
		case HpsPaxEntryModes_Chip:
			return @"Chip";
		case HpsPaxEntryModes_ChipFallBackSwipe:
			return @"ChipFallBackSwipe";
		default:
			return @"";
	}

	return nil; // Keep the compiler happy - does not understand above line never returns!
}

+ (NSString*)applicationCryptogramTypeToString:(ApplicationCrytogramType)cryptoType
{
	switch(cryptoType) {
		case TC:
			return @"TC";
		case ARQC:
			return @"ARQC";
}
	[NSException raise:NSInvalidArgumentException format:@"The given crypto type, %ld, is not known.", (long)cryptoType];
	return nil; // Keep the compiler happy - does not understand above line never returns!
}
@end
