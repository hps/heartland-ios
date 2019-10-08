#import <Foundation/Foundation.h>
#import "HpsPaxMessageIDs.h"

#define HpsControlCodes_STX 0x02
#define HpsControlCodes_ETX 0x03
#define HpsControlCodes_FS 0x1c
#define HpsControlCodes_US 0x1f

//#define HpsControlCodes_ACK 0x06
//#define HpsControlCodes_NAK 0x15
//#define HpsControlCodes_ENQ 0x05
//#define HpsControlCodes_GS 0x1d
//#define HpsControlCodes_EOT 0x04
//#define HpsControlCodes_RS 0x1e
//#define HpsControlCodes_COMMA 0x2c
//#define HpsControlCodes_COLON 0x3a
//#define HpsControlCodes_PTGS 0x7c

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
