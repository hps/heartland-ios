#import "HpaEnums.h"

@implementation HpaEnums

NSString * const HPA_MSG_ID_toString[] = {

	[ LANE_OPEN ] = @"LaneOpen",
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
    [ CAPTURE ] = @"CreditAuthComplete",
    [ SEND_SAF ] = @"SendSAF",
    [ GET_DIAGNOSTIC_REPORT ] = @"GetDiagnosticReport",
    [ EXECUTE_EOD ] = @"EOD",
    [ SEND_FILE] = @"SendFile"
};

NSString * const HPA_DOWNLOAD_TIME_toString[] = {

	[ NOW ] = @"NOW",
	[ EOD ] = @"EOD"
};

NSString * const HPA_DOWNLOAD_URL_toString[] = {

	[ TEST ] = @"SSLHPS.TEST.HPSDNLD.NET",
	[ PROD ] = @"SSLHPS.PROD.HPSDNLD.NET"
};

NSString * const HPA_DOWNLOAD_TYPE_toString[] = {

	[ FULL ] = @"FULL",
	[ PARTIAL ] = @"PARTIAL"
};

NSString * const HPA_CARD_GROUP_toString[] = {

	[ CREDIT ] = @"Credit",
	[ DEBIT ] = @"Debit",
	[ GIFT ] = @"Gift",
	[ EBT ] = @"EBT",
	[ ALL ] = @"All"
};
NSString * const HPA_SUMMARY_TYPE_toString[] = {
    
    [ APPROVED ] = @"APPROVED SAF SUMMARY",
    [ PENDING ] = @"PENDING SAF SUMMARY",
    [ DECLINED ] = @"DECLINED SAF SUMMARY",
    [ OFFLINE_APPROVED ] = @"OFFLINE APPROVED SAF SUMMARY",
    [ PARTIALLY_APPROVED ] = @"PARTIALLY APPROVED  SAF SUMMARY",
    [ VOID_APPROVED ] = @"APPROVED SAF VOID SUMMARY",
    [ VOID_PENDING ] = @"PENDING SAF VOID SUMMARY",
    [ VOID_DECLINED ] = @"DECLINED SAF VOID SUMMARY"
};

@end
