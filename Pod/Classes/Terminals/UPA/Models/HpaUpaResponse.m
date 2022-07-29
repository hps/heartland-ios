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

    JsonDoc* cmdData = [response get:@"data"];
    
    if ([cmdData has:@"EcrId"]) {
        self.ecrId = (NSString*)[cmdData getValue:@"EcrId"];
    }
    
    if ([cmdData has:@"requestId"]) {
        self.requestId = (NSString*)[cmdData getValue:@"requestId"];
    }
    
    if ([cmdData has:@"response"]) {
        self.transactionType = (NSString*)[cmdData get:@"response"];
    }
    
    if ([cmdData has:@"cmdResult"]) {
        JsonDoc* cmdResult = [cmdData get:@"cmdResult"];

        if ([cmdData has:@"cmdResult"]) {
            self.result = (NSString*)[cmdResult getValue:@"result"];
            self.status = (NSString*)[cmdResult getValue:@"result"];
            self.deviceResponseCode = (NSString*)[cmdResult getValue:@"errorCode"];
            self.deviceResponseMessage = (NSString*)[cmdResult getValue:@"errorMessage"];
        }
    }
    
    if (![cmdData has:@"data"]) {
        return self;
    }
    
    JsonDoc* data = [cmdData get:@"data"];
    
    self.multipleMessage = (NSString*)[data getValue:@"multipleMessage"];
    self.deviceSerialNumber = (NSString*)[data getValue:@"deviceSerialNum"];
    self.upaAppVersion = (NSString*)[data getValue:@"appVersion"];
    self.upaOsVersion = (NSString*)[data getValue:@"OsVersion"];
    self.upaEmvSdkVersion = (NSString*)[data getValue:@"EmvSdkVersion"];
    self.upaContactlessSdkVersion = (NSString*)[data getValue:@"CTLSSdkVersion"];
    
    if ([data has:@"host"]) {
        JsonDoc* host = [data get:@"host"];
        
        self.transactionId = (NSString*)[host getValue:@"responseId"];
        self.transactionTime = (NSString*)[host getValue:@"respDateTime"];
        self.gatewayRspMsg = (NSString*)[host getValue:@"gatewayResponseMessage"];
        self.gatewayRspCode = (NSString*)[host getValue:@"gatewayRespCode"];
        self.responseCode = (NSString*)[host getValue:@"responseCode"];
        self.responseText = (NSString*)[host getValue:@"responseText"];
        self.terminalRefNumber = (NSString*)[host getValue:@"tranNo"];
        self.issuerRefNumber = (NSString*)[host getValue:@"referenceNumber"];
        self.referenceNumber = (NSString*)[host getValue:@"referenceNumber"];
        self.approvalCode = (NSString*)[host getValue:@"approvalCode"];
        self.avsResultCode = (NSString*)[host getValue:@"AvsResultCode"];
        self.avsResultText = (NSString*)[host getValue:@"AvsResultText"];
        self.cvvResponseCode = (NSString*)[host getValue:@"CvvResultCode"];
        self.cvvResponseText = (NSString*)[host getValue:@"CvvResultText"];
        self.authorizedAmount = (NSString*)[host getValue:@"authorizedAmount"];
        self.partialApproval = (NSString*)[host getValue:@"partialApproval"];
        self.batchId = (NSString*)[host getValue:@"batchId"];
        self.cardBrandTransactionId = (NSString*)[host getValue:@"cardBrandTransId"];

        if ([host has:@"cashbackAmount"]) {
            self.cashBackAmount = [NSDecimalNumber decimalNumberWithString:(NSString*)[host getValue:@"cashbackAmount"]];
        }

        if ([host has:@"totalAmount"]) {
            self.transactionAmount = [NSDecimalNumber decimalNumberWithString:(NSString*)[host getValue:@"totalAmount"]];
        }

        if ([host has:@"surcharge"]) {
            self.merchantFee = [NSDecimalNumber decimalNumberWithString:(NSString*)[host getValue:@"surcharge"]];
        }

        if ([host has:@"balanceDue"]) {
            self.balanceAmount = [NSDecimalNumber decimalNumberWithString:(NSString*)[host getValue:@"balanceDue"]];
            self.balanceDueAmount = (NSString*)[host getValue:@"balanceDue"];
        }

        if ([host has:@"tipAmount"] || [host has:@"additionalTipAmount"]) {
            NSDecimalNumber* tip = [NSDecimalNumber decimalNumberWithString:@"0.00"];

            if ([host has:@"tipAmount"]) {
                tip = [tip decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:(NSString*)[host getValue:@"tipAmount"]]];
            }

            if ([host has:@"additionalTipAmount"]) {
                tip = [tip decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:(NSString*)[host getValue:@"additionalTipAmount"]]];
            }

            self.tipAmount = tip;
        }
        
        if ([host has:@"tokenValue"]) {
            self.tokenData = [[HpsTokenData alloc] init];
            self.tokenData.tokenValue = (NSString*)[host getValue:@"tokenValue"];
        }
        
    }
    
    if ([data has:@"payment"]) {
        JsonDoc* payment = [data get:@"payment"];
        self.cardType = (NSString*)[payment getValue:@"cardType"];
        self.paymentType = (NSString*)[payment getValue:@"paymentType"];
        self.entryMethod = (NSString*)[payment getValue:@"cardAcquisition"];
        self.maskedCardNumber = (NSString*)[payment getValue:@"maskedPan"];
        self.signatureLine = (NSString*)[payment getValue:@"signatureLine"];
        self.pinVerified = (NSString*)[payment getValue:@"PinVerified"];
        self.storeAndForward = (NSString*)[payment getValue:@"storeAndForward"];
        self.invoiceNbr = (NSString*)[payment getValue:@"invoiceNbr"];
        self.cardholderName = (NSString*)[payment getValue:@"cardHolderName"];
    }
    
    if ([data has:@"emv"]) {
        JsonDoc* emv = [data get:@"emv"];
        self.applicationName = (NSString*)[emv getValue:@"50"]; // convert from hex
        self.applicationId = (NSString*)[emv getValue:@"9F06"];
        self.applicationPrefferedName = (NSString*)[emv getValue:@"9F12"]; // convert from hex
        self.applicationCrytptogram = (NSString*)[emv getValue:@"9F26"];
        
        NSString* cryptotype = (NSString*)[emv getValue:@"9F27"];
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
