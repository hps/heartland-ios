#import <Foundation/Foundation.h>
#import "HpsPaxMessageIDs.h"

typedef NS_ENUM(Byte, HpsControlCodes) {
    HpsControlCodes_STX = 0x02,
    HpsControlCodes_ETX = 0x03,
    HpsControlCodes_ACK = 0x06,
    HpsControlCodes_NAK = 0x15,
    HpsControlCodes_ENQ = 0x05,
    HpsControlCodes_FS = 0x1C,
    HpsControlCodes_GS = 0x1D,
    HpsControlCodes_EOT = 0x04,
    HpsControlCodes_US = 0x1F,
    HpsControlCodes_RS = 0x1E,
    HpsControlCodes_COMMA = 0x2C,
    HpsControlCodes_COLON = 0x3A,
    HpsControlCodes_PTGS = 0x7C
};

typedef NS_ENUM(NSInteger, HpsConnectionModes) {
    HpsConnectionModes_SERIAL,
    HpsConnectionModes_TCP_IP,
    HpsConnectionModes_SSL_TCP,
    HpsConnectionModes_HTTP
};

typedef NS_ENUM(NSInteger, HpsBaudRate) {
    HpsBaudRate_r38400 = 38400,
    HpsBaudRate_r57600 = 57600,
    HpsBaudRate_r19200 = 19200,
    HpsBaudRate_r115200 = 115200
};

typedef NS_ENUM(NSInteger, HpsParity) {
    HpsParity_None = 0,
    HpsParity_Odd,
    HpsParity_Even,
};

typedef NS_ENUM(NSInteger, HpsStopBits) {
    HpsStopBits_One = 1,
    HpsStopBits_Two
};

typedef NS_ENUM(NSInteger, HpsDataBits) {
    HpsDataBits_Seven = 7,
    HpsDataBits_Eight = 8
};

@interface HpsTerminalEnums : NSObject

FOUNDATION_EXPORT NSString *const PAX_DEVICE_VERSION;
+ (BOOL) isControlCode:(Byte)code;
+ (NSString*) controlCodeString:(Byte)code;
+ (NSString *) controlCodeAsciValue:(Byte)code;
+ (NSString*)entryModeToString:(HpsPaxEntryModes)entryMode;
+ (NSString*)applicationCryptogramTypeToString:(ApplicationCrytogramType)cryptoType;

@end
