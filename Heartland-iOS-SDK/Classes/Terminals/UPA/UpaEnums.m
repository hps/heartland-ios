#import "UpaEnums.h"

@implementation UpaEnums

NSString * const UPA_MSG_ID_toString[] = {

    [ UPA_MSG_ID_RESET ] = @"CancelTransaction",
    [ UPA_MSG_ID_REBOOT ] = @"Reboot",
    [ UPA_MSG_ID_BATCH_CLOSE ] = @"CloseBatch",
    [ UPA_MSG_ID_GET_BATCH_REPORT ] = @"GetBatchReport",
    [ UPA_MSG_ID_SALE ] = @"Sale",
    [ UPA_MSG_ID_REFUND ] = @"Refund",
    [ UPA_MSG_ID_VOID ] = @"Void",
    [ UPA_MSG_ID_CARD_VERIFY ] = @"CardVerify",
    [ UPA_MSG_ID_AUTH ] = @"PreAuth",
    [ UPA_MSG_ID_BALANCE ] = @"BalanceInquiry",
    [ UPA_MSG_ID_ADD_VALUE ] = @"AddValue",
    [ UPA_MSG_ID_TIP_ADJUST ] = @"TipAdjust",
    [ UPA_MSG_ID_GET_INFO_REPORT ] = @"GetAppInfo",
    [ UPA_MSG_ID_CAPTURE ] = @"AuthCompletion",
    [ UPA_MSG_ID_SEND_SAF ] = @"SendSAF",
    [ UPA_MSG_ID_GET_DIAGNOSTIC_REPORT ] = @"GetDiagnosticReport",
    [ UPA_MSG_ID_EXECUTE_EOD ] = @"EODProcessing",
    [ UPA_MSG_ID_REVERSAL ] = @"Reversal",
    [ UPA_MSG_ID_LINE_ITEM_DISPLAY ] = @"LineItemDisplay",
    [ UPA_MSG_ID_DELETE_PREAUTH ] = @"DeletePreAuth",
    [ UPA_MSG_ID_GET_SIGNATURE ] = @"GetSignature",
};
NSString * const UPA_CARD_GROUP_toString[] = {

    [ UPA_CARD_GROUP_CREDIT ] = @"Credit",
    [ UPA_CARD_GROUP_DEBIT ] = @"Debit",
    [ UPA_CARD_GROUP_GIFT ] = @"Gift",
    [ UPA_CARD_GROUP_EBT ] = @"EBT",
    [ UPA_CARD_GROUP_ALL ] = @"All"
};
NSString * const UPA_MSG_TYPE_toString[] = {

    [UPA_MSG_TYPE_UNKNOWN] = @"UNKNOWN",
    [UPA_MSG_TYPE_ACK] = @"ACK",
    [UPA_MSG_TYPE_NAK] = @"NAK",
    [UPA_MSG_TYPE_READY] = @"READY",
    [UPA_MSG_TYPE_BUSY] = @"BUSY",
    [UPA_MSG_TYPE_TIMEOUT] = @"TO",
    [UPA_MSG_TYPE_MSG] = @"MSG",
    [UPA_MSG_TYPE_DATA] = @"DATA",
};

NSString * const UPA_MSG_PROMPT_toString[] = {
    [UPA_MSG_TYPE_PROMPT1] = @"Please sign",
};

@end
