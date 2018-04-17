 //  Copyright (c) 2017 Heartland Payment Systems. All rights reserved.

#import <Foundation/Foundation.h>
extern NSString * const HSIP_MSG_ID_toString[];

typedef NS_ENUM(NSInteger, MessageFormat)
{
	HeartSIP,
	Visa2nd
};

typedef NS_ENUM(NSInteger, HSIP_MSG_ID) {
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
	CAPTURE
};

@interface HeartSIPEnums : NSObject

@end
