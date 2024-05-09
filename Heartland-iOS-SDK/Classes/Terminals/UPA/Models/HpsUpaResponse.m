#import "HpsUpaResponse.h"
#import "HpsHpaSharedParams.h"
#import "NSString+HexParser.h"

@interface HpsUpaResponse()

@property (readwrite,retain) NSMutableDictionary *params;

@end

static int IsFieldEnable;

@implementation HpsUpaResponse

-(id)init{
    if(self = [super init])
        {
        IsFieldEnable = NO;
        [HpsHpaSharedParams getInstance].class_type = RESPONSE;

        }
    return self;
}

-(id)initWithJSONDoc:(JsonDoc*)response
{
    self = [self init];

    JsonDoc* cmdData = [response get:@"data"];

    if ([cmdData has:@"EcrId"]) {
        self.ecrId = [cmdData getValueAsString:@"EcrId"];
    }

    if ([cmdData has:@"requestId"]) {
        self.requestId = [cmdData getValueAsString:@"requestId"];
    }

    if ([cmdData has:@"response"]) {
        self.transactionType = [cmdData getValueAsString:@"response"];
    }

    if ([cmdData has:@"cmdResult"]) {
        JsonDoc* cmdResult = [cmdData get:@"cmdResult"];

        if ([cmdData has:@"cmdResult"]) {
            self.result = [cmdResult getValueAsString:@"result"];
            self.status = [cmdResult getValueAsString:@"result"];
            self.deviceResponseCode = [cmdResult getValueAsString:@"errorCode"];
            self.deviceResponseMessage = [cmdResult getValueAsString:@"errorMessage"];
        }
    }

    if (![cmdData has:@"data"]) {
        return self;
    }

    JsonDoc* data = [cmdData get:@"data"];

    self.multipleMessage = [data getValueAsString:@"multipleMessage"];
    self.deviceSerialNumber = [data getValueAsString:@"deviceSerialNum"];
    self.upaAppVersion = [data getValueAsString:@"appVersion"];
    self.upaOsVersion = [data getValueAsString:@"OsVersion"];
    self.upaEmvSdkVersion = [data getValueAsString:@"EmvSdkVersion"];
    self.upaContactlessSdkVersion = [data getValueAsString:@"CTLSSdkVersion"];

    if ([data has:@"host"]) {
        JsonDoc* host = [data get:@"host"];

        self.transactionId = [host getValueAsString:@"responseId"];
        self.transactionTime = [host getValueAsString:@"respDateTime"];
        self.gatewayRspMsg = [host getValueAsString:@"gatewayResponseMessage"];
        self.gatewayRspCode = [host getValueAsString:@"gatewayResponseCode"];
        self.responseCode = [host getValueAsString:@"responseCode"];
        self.responseText = [host getValueAsString:@"responseText"];
        self.terminalRefNumber = [host getValueAsString:@"tranNo"];
        self.issuerRefNumber = [host getValueAsString:@"referenceNumber"];
        self.referenceNumber = [host getValueAsString:@"referenceNumber"];
        self.approvalCode = [host getValueAsString:@"approvalCode"];
        self.avsResultCode = [host getValueAsString:@"AvsResultCode"];
        self.avsResultText = [host getValueAsString:@"AvsResultText"];
        self.cvvResponseCode = [host getValueAsString:@"CvvResultCode"];
        self.cvvResponseText = [host getValueAsString:@"CvvResultText"];
        self.authorizedAmount = [host getValueAsString:@"authorizedAmount"];
        self.partialApproval = [host getValueAsString:@"partialApproval"];
        self.batchId = [host getValueAsString:@"batchId"];
        self.cardBrandTransactionId = [host getValueAsString:@"cardBrandTransId"];

        if ([host has:@"cashbackAmount"]) {
            self.cashBackAmount = [NSDecimalNumber decimalNumberWithString:[host getValueAsString:@"cashbackAmount"]];
        }

        if ([host has:@"totalAmount"]) {
            self.transactionAmount = [NSDecimalNumber decimalNumberWithString:[host getValueAsString:@"totalAmount"]];
        }

        if ([host has:@"surcharge"]) {
            self.merchantFee = [NSDecimalNumber decimalNumberWithString:[host getValueAsString:@"surcharge"]];
        }

        if ([host has:@"balanceDue"]) {
            self.balanceAmount = [NSDecimalNumber decimalNumberWithString:[host getValueAsString:@"balanceDue"]];
            self.balanceDueAmount = [host getValueAsString:@"balanceDue"];
        }

        if ([host has:@"tipAmount"] || [host has:@"additionalTipAmount"]) {
            NSDecimalNumber* tip = [NSDecimalNumber decimalNumberWithString:@"0.00"];

            if ([host has:@"tipAmount"]) {
                tip = [tip decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:[host getValueAsString:@"tipAmount"]]];
            }

            if ([host has:@"additionalTipAmount"]) {
                tip = [tip decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:[host getValueAsString:@"additionalTipAmount"]]];
            }

            self.tipAmount = tip;
        }

        if ([host has:@"tokenValue"]) {
            self.tokenData = [[HpsTokenData alloc] init];
            self.tokenData.tokenValue = [host getValueAsString:@"tokenValue"];
        }

    }

    if ([data has:@"payment"]) {
        JsonDoc* payment = [data get:@"payment"];
        self.cardType = [payment getValueAsString:@"cardType"];
        self.paymentType = [payment getValueAsString:@"paymentType"];
        self.entryMethod = [payment getValueAsString:@"cardAcquisition"];
        self.maskedCardNumber = [payment getValueAsString:@"maskedPan"];
        self.signatureLine = [payment getValueAsString:@"signatureLine"];
        self.pinVerified = [payment getValueAsString:@"PinVerified"];
        self.storeAndForward = [payment getValueAsString:@"storeAndForward"];
        self.invoiceNbr = [payment getValueAsString:@"invoiceNbr"];
        self.cardholderName = [payment getValueAsString:@"cardHolderName"];
        self.signatureData = [payment getValueAsString:@"signatureData"];
    }

    if ([data has:@"emv"]) {
        JsonDoc* emv = [data get:@"emv"];
        self.applicationName = [[emv getValueAsString:@"50"] convertedFromHexadecimal];
        self.applicationId = [emv getValueAsString:@"9F06"];
        self.applicationPrefferedName = [[emv getValueAsString:@"9F12"] convertedFromHexadecimal];
        self.applicationCrytptogram = [emv getValueAsString:@"9F26"];

        NSString* cryptotype = [emv getValueAsString:@"9F27"];
        if ([cryptotype isEqualToString:@"0"]) {
            self.applicationCryptogramType = AAC;
            self.applicationCryptogramTypeS = [HpsTerminalEnums applicationCryptogramTypeToString:self.applicationCryptogramType];
        } else if ([cryptotype isEqualToString:@"40"]) {
            self.applicationCryptogramType = TC;
            self.applicationCryptogramTypeS = [HpsTerminalEnums applicationCryptogramTypeToString:self.applicationCryptogramType];
        } else if ([cryptotype isEqualToString:@"80"]) {
            self.applicationCryptogramType = ARQC;
            self.applicationCryptogramTypeS = [HpsTerminalEnums applicationCryptogramTypeToString:self.applicationCryptogramType];
        }
        
        NSString *emvTSI = [emv getValueAsString:@"9B"];
        self.emvTSI = emvTSI;
        
        NSString *emvTVR = [emv getValueAsString:@"95"];
        self.emvTVR = emvTVR;
    }
    
    if ([data has:@"duplicate"]) {
        JsonDoc* duplicate = [data get:@"duplicate"];
        self.duplicate = [[HpsTransactionDuplicate alloc] init];
        self.duplicate.duplicateCardType = [duplicate getValueAsString:@"cardType"];
        self.duplicate.duplicateTotalAmount = [duplicate getValueAsString:@"totalAmount"];
        self.duplicate.duplicateApprovalCode = [duplicate getValueAsString:@"approvalCode"];
        self.duplicate.duplicateReferenceNumber = [duplicate getValueAsString:@"referenceNumber"];
        self.duplicate.duplicateTranDate = [duplicate getValueAsString:@"tranDate"];
        self.duplicate.duplicatePanLast4 = [duplicate getValueAsString:@"panLast4"];
    }

    return self;
}

-(void)setTransactionSummaryRecord:(TransactionSummaryRecord *)TransactionSummaryRecord{
    if (TransactionSummaryRecord) {
        [[HpsHpaSharedParams getInstance]addTranasactionSummaryRecords:TransactionSummaryRecord];
    }
}

-(void)setCardSummaryRecord:(CardSummaryRecord *)CardSummaryRecord{
    if (CardSummaryRecord) {
        [[HpsHpaSharedParams getInstance]addCardSummaryRecords:CardSummaryRecord];
    }
}

-(void)setLastResponse:(HpsLastResponse *)LastResponse{
    if (LastResponse) {
        [[HpsHpaSharedParams getInstance]setLastResponseData:LastResponse];
    }
}

-(void)setRecord:(Record *)Record
{
    if (Record.TableCategory) {
            //        NSLog(@"TableCategory = %@",Record.TableCategory);
            //        NSLog(@"Fields = %@", Record.Fields);
        [[HpsHpaSharedParams getInstance]addParaMeter:Record.TableCategory withValues:Record.Fields];
        [[HpsHpaSharedParams getInstance]addParamInArray:Record.TableCategory withValues:Record.FieldsArray];
    }else {
            //NSLog(@"Extra Fields = %@", Record.Fields);
        [[HpsHpaSharedParams getInstance]addParaMeter:Record.TableCategory withValues:Record.Fields];
        [[HpsHpaSharedParams getInstance]addParamInArray:Record.TableCategory withValues:Record.FieldsArray];
    }
}

// MARK: General

/// if a response failed
- (BOOL)isSuccess {
    return [self.status isEqualToString:@"Success"];
}

/// combines device response code & message
- (NSString *)responseDescription {
    NSMutableArray *parts = [NSMutableArray new];
    if (self.deviceResponseCode) [parts addObject:self.deviceResponseCode];
    if (self.deviceResponseMessage) [parts addObject:self.deviceResponseMessage];
    return ![parts count] ? nil : [parts componentsJoinedByString:@" - "];
}

// MARK: Error

/// message should be in the format:
///     "Transaction was rejected because it is a duplicate. Subject '200034100740'."
- (NSString *)duplicateTransactionId {
    if (![self isDuplicateTransactionError]) return nil;
    // check gateway message exists
    NSString *message = self.gatewayRspMsg;
    if (![message length]) return nil;
    // find last word of message (should be id in quotes)
    NSArray *parts = [message componentsSeparatedByString:@" "];
    NSString *transactionId = [parts lastObject];
    if (!transactionId) return nil;
    // strip down to a number value
    transactionId = [[transactionId componentsSeparatedByCharactersInSet:
                      [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                     componentsJoinedByString:@""];
    // check number value left
    return [transactionId integerValue] ? transactionId : nil;
}

/// if a response indicates the host
/// flagged a transaction as a duplicate
- (BOOL)isDuplicateTransactionError {
    return ([self.deviceResponseCode isEqualToString:@"HOST001"]
            && [self.responseCode isEqualToString:@"2"]);
}

/// if a response indicates that the UPA terminal
/// did not receive a response from the host
- (BOOL)isHostCommunicationError {
    return [self.deviceResponseCode isEqualToString:@"HOST002"];
}

/// failed UPA terminal response formatted
/// as an error object
- (NSError *_Nullable)responseError {
    if ([self isSuccess]) { return nil; }
    NSString *domain = @"com.mobilebytes.upa";
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    [userInfo setValue:[self responseDescription] forKey:NSLocalizedDescriptionKey];
    [userInfo setValue:self.gatewayRspMsg forKey:NSLocalizedFailureReasonErrorKey];
    return [NSError errorWithDomain:domain code:1 userInfo:userInfo];
}

@end
