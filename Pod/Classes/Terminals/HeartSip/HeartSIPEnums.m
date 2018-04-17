	//  Copyright (c) 2017 Heartland Payment Systems. All rights reserved.

#import "HeartSIPEnums.h"

@implementation HeartSIPEnums

NSString * const HSIP_MSG_ID_toString[] = {

	[ LANE_OPEN] = @"LaneOpen",
	[ LANE_CLOSE ] = @"LaneClose",
	[ RESET ] = @"Reset",
	[ REBOOT ] = @"Reboot",
	[ BATCH_CLOSE ] = @"CloseBatch",
	[ GET_BATCH_REPORT ] = @"GetBatchReport",
	[ CREDIT_SALE ] = @"Sale",
	[ CREDIT_REFUND ] = @"Refund",
	[ CREDIT_VOID ] = @"Void",
	[ CARD_VERIFY ] = @"CardVerify",
	[ CREDIT_AUTH ] = @"CreditAuth",
	[ BALANCE ] = @"BalanceInquiry",
	[ ADD_VALUE ] = @"AddValue",
	[ TIP_ADJUST ] = @"TipAdjust",
	[ GET_INFO_REPORT ] = @"GetAppInfoReport",
	[ CAPTURE ] = @"CreditAuthComplete"
};

@end
