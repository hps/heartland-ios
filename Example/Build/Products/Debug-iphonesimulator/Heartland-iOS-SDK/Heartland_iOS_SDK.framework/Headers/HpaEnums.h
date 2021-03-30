#import <Foundation/Foundation.h>
extern NSString * const HPA_MSG_ID_toString[];
extern NSString * const HPA_DOWNLOAD_TIME_toString[];
extern NSString * const HPA_DOWNLOAD_URL_toString[];
extern NSString * const HPA_DOWNLOAD_TYPE_toString[];
extern NSString * const HPA_CARD_GROUP_toString[];
extern NSString * const HPA_SUMMARY_TYPE_toString[];

typedef NS_ENUM(NSInteger, MessageFormat)
{
	HPA,
	Visa2nd
};

typedef NS_ENUM(NSInteger, HPA_MSG_ID) {
	LANE_OPEN,
	LANE_CLOSE,
	RESET,
	REBOOT,
	BATCH_CLOSE,
	GET_BATCH_REPORT,
	CREDIT_SALE,
	CREDIT_REFUND,
	CREDIT_VOID,
	CARD_VERIFY,
	CREDIT_AUTH,
	BALANCE,
	ADD_VALUE,
	TIP_ADJUST,
	GET_INFO_REPORT,
	CAPTURE,
    SEND_SAF,
    GET_DIAGNOSTIC_REPORT,
    EXECUTE_EOD,
    SEND_FILE,
    NOTIFICATION
};

typedef NS_ENUM(NSInteger, HPA_DOWNLOAD_TIME) {
	NOW,
	EOD
};

typedef NS_ENUM(NSInteger, HPA_DOWNLOAD_URL) {
	TEST,
	PROD
};

typedef NS_ENUM(NSInteger, HPA_DOWNLOAD_TYPE) {
	FULL,
	PARTIAL
};

typedef NS_ENUM(NSInteger, HPA_CARD_GROUP) {
	CREDIT,
	DEBIT,
	GIFT,
	EBT,
	ALL
};
typedef NS_ENUM(NSInteger, HPA_SUMMARY_TYPE) {
    APPROVED,
    PARTIALLY_APPROVED,
    VOID_APPROVED,
    PENDING,
    VOID_PENDING,
    DECLINED,
    VOID_DECLINED,
    OFFLINE_APPROVED
};

@interface HpaEnums : NSObject

@end
