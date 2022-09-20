#import "HpsUpaResponse.h"
#import "HpsHpaSharedParams.h"

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
    self.transactionType = [response getValueAsString:@"response"];

    JsonDoc* cmdData = [response get:@"data"];

    if ([cmdData has:@"EcrId"]) {
        self.ecrId = [cmdData getValueAsString:@"EcrId"];
    }

    if ([cmdData has:@"requestId"]) {
        self.requestId = [cmdData getValueAsString:@"requestId"];
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
        self.gatewayRspCode = [host getValueAsString:@"gatewayRespCode"];
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
    }

    if ([data has:@"emv"]) {
        JsonDoc* emv = [data get:@"emv"];
        self.applicationName = [emv getValueAsString:@"50"]; // convert from hex
        self.applicationId = [emv getValueAsString:@"9F06"];
        self.applicationPrefferedName = [emv getValueAsString:@"9F12"]; // convert from hex
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

@end
