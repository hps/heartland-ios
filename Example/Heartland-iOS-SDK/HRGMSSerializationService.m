//
//  HRGMSSerializationService.m
//  Heartland-iOS-SDK_Example
//
//  Created by Desimini, Wilson on 6/17/21.
//  Copyright © 2021 Shaunti Fondrisi. All rights reserved.
//

#import "HRGMSSerializationService.h"

@implementation HRGMSSerializationService

+ (NSMutableDictionary *)transactionDetailJSONFromResponse:(HpsTerminalResponse *)response {
    NSDictionary *responseJSON = [HRGMSSerializationService jsonFromHpsTerminalResponse:response];
    NSMutableDictionary *detailInfo = NSMutableDictionary.new;
    [detailInfo setValue:response.cardholderName forKey:@"AccountName"];
    [detailInfo setValue:responseJSON[@"hostResponse"][@"authCode"] forKey:@"AuthCode"];
    [detailInfo setValue:response.entryMethod forKey:@"EntryMethod"];
    [detailInfo setValue:responseJSON forKey:@"Response"];
    return detailInfo;
}

+ (NSDictionary *)jsonFromGMSObject:(id)gmsObject {
    if ([gmsObject isKindOfClass:HpsTerminalResponse.class]) {
        return [HRGMSSerializationService jsonFromHpsTerminalResponse:gmsObject];
    } else if ([gmsObject isKindOfClass:HpsPaxHostResponse.class]) {
        return [HRGMSSerializationService jsonFromHpsPaxHostResponse:gmsObject];
    } else if ([gmsObject isKindOfClass:HpsTokenData.class]) {
        return [HRGMSSerializationService jsonFromHpsTokenData:gmsObject];
    }
    
    return NSDictionary.new;
}

+ (NSDictionary *)jsonFromHpsTerminalResponse:(HpsTerminalResponse *)response {
    NSMutableDictionary *json = NSMutableDictionary.new;
    [json setValue:response.status forKey:@"status"];
    [json setValue:response.command forKey:@"command"];
    [json setValue:response.version forKey:@"version"];
    [json setValue:response.deviceResponseCode forKey:@"deviceResponseCode"];
    [json setValue:response.deviceResponseMessage forKey:@"deviceResponseMessage"];
    [json setValue:response.responseText forKey:@"responseText"];
    [json setValue:response.transactionId forKey:@"transactionId"];
    [json setValue:response.terminalRefNumber forKey:@"terminalRefNumber"];
    [json setValue:[HRGMSSerializationService jsonFromHpsTokenData:response.tokenData] forKey:@"tokenData"];
    [json setValue:response.signatureStatus forKey:@"signatureStatus"];
    [json setValue:response.transactionType forKey:@"transactionType"];
    [json setValue:response.entryMethod forKey:@"entryMethod"];
    [json setValue:response.maskedCardNumber forKey:@"maskedCardNumber"];
    [json setValue:@(response.entryMode) forKey:@"entryMode"];
    [json setValue:response.approvalCode forKey:@"approvalCode"];
    [json setValue:response.transactionAmount forKey:@"transactionAmount"];
    [json setValue:response.amountDue forKey:@"amountDue"];
    [json setValue:response.balanceAmount forKey:@"balanceAmount"];
    [json setValue:response.cardholderName forKey:@"cardholderName"];
    [json setValue:response.cardBin forKey:@"cardBin"];
    [json setValue:[NSNumber numberWithBool:response.cardPresent] forKey:@"cardPresent"];
    [json setValue:response.expirationDate forKey:@"expirationDate"];
    [json setValue:response.tipAmount forKey:@"tipAmount"];
    [json setValue:response.cashBackAmount forKey:@"cashBackAmount"];
    [json setValue:response.avsResultCode forKey:@"avsResultCode"];
    [json setValue:response.avsResultText forKey:@"avsResultText"];
    [json setValue:response.cvvResponseCode forKey:@"cvvResponseCode"];
    [json setValue:response.cvvResponseText forKey:@"cvvResponseText"];
    [json setValue:[NSNumber numberWithBool:response.taxExept] forKey:@"taxExept"];
    [json setValue:response.taxExeptId forKey:@"taxExeptId"];
    [json setValue:response.paymentType forKey:@"paymentType"];
    [json setValue:response.merchantFee forKey:@"merchantFee"];
    [json setValue:response.approvedAmount forKey:@"approvedAmount"];
    [json setValue:[HRGMSSerializationService jsonFromHpsPaxHostResponse:response.hostResponse] forKey:@"hostResponse"];
    [json setValue:response.applicationPrefferedName forKey:@"applicationPrefferedName"];
    [json setValue:response.applicationName forKey:@"applicationName"];
    [json setValue:response.applicationId forKey:@"applicationId"];
    [json setValue:response.applicationCrytptogram forKey:@"applicationCrytptogram"];
    [json setValue:@(response.applicationCryptogramType) forKey:@"applicationCryptogramType"];
    [json setValue:response.applicationCryptogramTypeS forKey:@"applicationCryptogramTypeS"];
    [json setValue:response.cardHolderVerificationMethod forKey:@"cardHolderVerificationMethod"];
    [json setValue:response.terminalVerficationResult forKey:@"terminalVerficationResult"];
    [json setValue:response.terminalSerialNumber forKey:@"terminalSerialNumber"];
    [json setValue:[NSNumber numberWithBool:response.storedResponse] forKey:@"storedResponse"];
    [json setValue:response.lastResponseTransactionId forKey:@"lastResponseTransactionId"];
    [json setValue:response.clientTransactionIdUUID.UUIDString forKey:@"clientTransactionIdUUID"];
    [json setValue:response.cardType forKey:@"cardType"];
    return json;
}

+ (NSDictionary *)jsonFromHpsPaxHostResponse:(HpsPaxHostResponse *)hostResponse {
    NSMutableDictionary *json = NSMutableDictionary.new;
    [json setValue:hostResponse.hostResponseCode forKey:@"hostResponseCode"];
    [json setValue:hostResponse.hostResponseMessage forKey:@"hostResponseMessage"];
    [json setValue:hostResponse.authCode forKey:@"authCode"];
    [json setValue:hostResponse.hostReferenceNumber forKey:@"hostReferenceNumber"];
    [json setValue:hostResponse.traceNumber forKey:@"traceNumber"];
    [json setValue:hostResponse.batchNumber forKey:@"batchNumber"];
    return [NSDictionary dictionaryWithDictionary:json];
}

+ (NSDictionary *)jsonFromHpsTokenData:(HpsTokenData *)tokenData {
    NSMutableDictionary *json = NSMutableDictionary.new;
    [json setValue:tokenData.type forKey:@"type"];
    [json setValue:tokenData.message forKey:@"message"];
    [json setValue:tokenData.code forKey:@"code"];
    [json setValue:tokenData.param forKey:@"param"];
    [json setValue:tokenData.tokenValue forKey:@"tokenValue"];
    [json setValue:tokenData.tokenExpire forKey:@"tokenExpire"];
    [json setValue:tokenData.tokenType forKey:@"tokenType"];
    [json setValue:tokenData.cardNumber forKey:@"cardNumber"];
    return [NSDictionary dictionaryWithDictionary:json];
}

@end
