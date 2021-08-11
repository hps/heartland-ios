//
//  HRGMSTransactionViewModel.m
//  Heartland-iOS-SDK_Example
//
//  Created by Desimini, Wilson on 6/17/21.
//  Copyright © 2021 Shaunti Fondrisi. All rights reserved.
//

#import "HRGMSDeviceManager.h"
#import "HRGMSTransactionViewModel.h"
#import "HRGMSSerializationService.h"

@implementation HRGMSTransactionViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self observeGMSTransactionNotifications];
    }
    return self;
}

- (void)didReceiveGMSTransactionStatusNotification:(NSNotification *)notification {
    [_view gmsTransactionViewDisplayStatus:
     [self textFromStatus:[notification.object integerValue]]];
}

- (void)didReceiveGMSTransactionResponseNotification:(NSNotification *)notification {
    HpsTerminalResponse *response = notification.object;
    
    if (response && response.gmsResponseIsApproval) {
        [_view gmsTransactionViewDisplayResponseSuccess];
    } else {
        [_view gmsTransactionViewDisplayResponseError:
         response ? response.deviceResponseCode : @"Transaction Cancelled"];
    }
    
    [_view gmsTransactionViewDisplayResponseBody:
     [self textFromResponseBody:response]];
}

- (void)gmsReturnSelected {
    [_view gmsTransactionViewResetResponseViews];
    
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:@"4.28"];
    NSString *referenceNumber = [NSString stringWithFormat:@"%ld", (NSInteger)NSDate.new.timeIntervalSince1970];
    GMSBuilderModel *returnModel = [GMSBuilderModel creditReturnModelWithAmount:amount referenceNumber:referenceNumber];
    [HRGMSDeviceManager.sharedInstance doTransactionWithModel:returnModel];
}

- (void)gmsSaleSelected {
    [_view gmsTransactionViewResetResponseViews];
    
    [HRGMSDeviceManager.sharedInstance doTransactionWithModel:
     [GMSBuilderModel creditSaleModelWithAmount:[NSDecimalNumber decimalNumberWithString:@"4.28"]
                                       gratuity:NSDecimalNumber.zero
                                referenceNumber:nil]];
}

- (void)observeGMSTransactionNotifications {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didReceiveGMSTransactionStatusNotification:)
                                               name:AppNotificationGMSTransactionStatus
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didReceiveGMSTransactionResponseNotification:)
                                               name:AppNotificationGMSTransactionResponse
                                             object:nil];
}

- (NSString *)textFromStatus:(HpsTransactionStatus)status {
    switch (status) {
        case HpsTransactionStatusWaitingForConfiguration:
            return @".waitingForConfiguration";
        case HpsTransactionStatusConfiguringTerminal:
            return @".configuringTerminal";
        case HpsTransactionStatusConfigurationFailedTryAgain:
            return @".configurationFailedTryAgain";
        case HpsTransactionStatusReady:
            return @".ready";
        case HpsTransactionStatusStarted:
            return @".started";
        case HpsTransactionStatusWaitingForCard:
            return @".waitingForCard";
        case HpsTransactionStatusInsertCard:
            return @".insertCard";
        case HpsTransactionStatusRemoveCard:
            return @".removeCard";
        case HpsTransactionStatusCardRemoved:
            return @".cardRemoved";
        case HpsTransactionStatusPleaseWait:
            return @".pleaseWait";
        case HpsTransactionStatusPleaseSeePhone:
            return @".pleaseSeePhone";
        case HpsTransactionStatusUseMagstripe:
            return @".useMagstripe";
        case HpsTransactionStatusTryAgain:
            return @".tryAgain";
        case HpsTransactionStatusSwipeErrorReSwipe:
            return @".swipeErrorReSwipe";
        case HpsTransactionStatusNoEmvApps:
            return @".noEmvApps";
        case HpsTransactionStatusApplicationExpired:
            return @".applicationExpired";
        case HpsTransactionStatusCardReadError:
            return @".cardReadError";
        case HpsTransactionStatusProcessing:
            return @".processing";
        case HpsTransactionStatusProcessingDoNotRemoveCard:
            return @".processingDoNotRemoveCard";
        case HpsTransactionStatusPresentCard:
            return @".presentCard";
        case HpsTransactionStatusPresentCardAgain:
            return @".presentCardAgain";
        case HpsTransactionStatusInsertSwipeOrTryAnotherCard:
            return @".insertSwipeOrTryAnotherCard";
        case HpsTransactionStatusInsertOrSwipeCard:
            return @".insertOrSwipeCard";
        case HpsTransactionStatusMultipleCardDetected:
            return @".multipleCardDetected";
        case HpsTransactionStatusContactlessCardStillInField:
            return @".contactlessCardStillInField";
        case HpsTransactionStatusTransactionTerminated:
            return @".transactionTerminated";
        case HpsTransactionStatusWaitingForTerminal:
            return @".waitingForTerminal";
        case HpsTransactionStatusCardDetected:
            return @".cardDetected";
        case HpsTransactionStatusCardBlocked:
            return @".cardBlocked";
        case HpsTransactionStatusNotAuthorized:
            return @".notAuthorized";
        case HpsTransactionStatusNotAcceptedRemoveCard:
            return @".notAcceptedRemoveCard";
        case HpsTransactionStatusFallbackToMSR:
            return @".fallbackToMSR";
        case HpsTransactionStatusFallbackToChip:
            return @".fallbackToChip";
        case HpsTransactionStatusWaitingForAmountConfirmation:
            return @".waitingForAmountConfirmation";
        case HpsTransactionStatusWaitingForAidSelection:
            return @".waitingForAidSelection";
        case HpsTransactionStatusWaitingForPostalCode:
            return @".waitingForPostalCode";
        case HpsTransactionStatusWaitingForSafApproval:
            return @".waitingForSafApproval";
        case HpsTransactionStatusCardHolderBypassedPIN:
            return @".cardHolderBypassedPIN";
        case HpsTransactionStatusProcessingSaf:
            return @".processingSaf";
        case HpsTransactionStatusRequestingOnlineProcessing:
            return @".requestingOnlineProcessing";
        case HpsTransactionStatusReversal:
            return @".reversal";
        case HpsTransactionStatusReversalInProgress:
            return @".reversalInProgress";
        case HpsTransactionStatusComplete:
            return @".complete";
        case HpsTransactionStatusCancel:
            return @".cancel";
        case HpsTransactionStatusCancelling:
            return @".cancelling";
        case HpsTransactionStatusCancelled:
            return @".cancelled";
        case HpsTransactionStatusError:
            return @".error";
        case HpsTransactionStatusUnknown:
            return @".unknown";
        case HpsTransactionStatusTerminalDeclined:
            return @".terminalDeclined";
    }
}

- (NSString *)textFromResponseBody:(HpsTerminalResponse *)response {
    if (!response) {
        return @"(no response)";
    }
    
    NSDictionary *info = [HRGMSSerializationService jsonFromGMSObject:response];
    NSMutableString *text = NSMutableString.new;
    
    for (NSString *key in info.allKeys) {
        [text appendFormat:@"%@ - %@\n", key, info[key]];
    }
    
    return [NSString stringWithString:text];
}

@end
