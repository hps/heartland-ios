#import "HpsPaxDeviceResponse.h"

@implementation HpsPaxDeviceResponse

- (id) initWithMessageID:(NSString*)messageId andBuffer:(NSData*)buffer{
	if((self = [super initWithMessageID:messageId andBuffer:buffer]))
		{
			[self parseResponse];

		}
	return self;
}

- (HpsBinaryDataScanner*) parseResponse{
	return [super parseResponse];
}

- (void) mapResponse{

	@try {
		if (self.hostResponse != nil) {
			self.responseCode = self.hostResponse.hostResponseCode;
			self.responseText = self.hostResponse.hostResponseMessage;
			self.approvalCode = self. hostResponse.hostResponseCode;
            
            if (!self.hostResponse.traceNumber.length && self.traceResponse.ecrRefNumber != nil) {
                self.hostResponse.traceNumber = self.traceResponse.ecrRefNumber;
            }
		}
		if (self.amountResponse != nil){
            self.transactionAmount = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:self.amountResponse.approvedAmount] decimalValue]];
            self.amountDue = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:self.amountResponse.amountDue] decimalValue]];
            self.tipAmount = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:self.amountResponse.tipAmount] decimalValue]];
            self.cashBackAmount = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:self.amountResponse.cashBackAmount] decimalValue]];
            self.merchantFee = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:self.amountResponse.merchantFee] decimalValue]];
            
            self.surchargeFee = [[NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:self.amountResponse.surchargeFee] decimalValue]] stringValue];
		}

		if (self.accountResponse != nil) {
			self.maskedCardNumber = self.accountResponse.accountNumber;
			self.entryMode = (int)self.accountResponse.entryMode;
			self.expirationDate = self.accountResponse.expireDate;
			self.paymentType = self.accountResponse.cardType;
            self.cardholderName = self.accountResponse.cardHolder;
			self.cvvResponseCode = self.accountResponse.cvdApprovalCode;
			self.cvvResponseText = self.accountResponse.cvdMessage;
			self.cardPresent = self.accountResponse.cardPressent;

		}
		if (self.traceResponse != nil) {
			self.referenceNumber = self.traceResponse.referenceNumber;
			self.terminalRefNumber = self.traceResponse.transactionNunmber;
		}
		if (self.avsResponse != nil) {
			self.avsResultCode = self.avsResponse.avsResponseCode;
			self.avsResultText = self.avsResponse.avsResponseMessage;
		}
		if (self.commercialResponse != nil)
			{
			self.taxExept = self.commercialResponse.taxExept;
			self.taxExeptId = self.commercialResponse.taxExeptId;
			}
		if (self.extDataResponse != nil) {
            id transactionIdObject = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_HOST_REFERENCE_NUMBER];
            if ([transactionIdObject respondsToSelector:@selector(stringValue)]) {
                self.transactionId = [transactionIdObject stringValue];
            } else if ([transactionIdObject isKindOfClass:[NSString class]]) {
                self.transactionId = transactionIdObject;
            }
			self.clientTransactionId = [self.extDataResponse.collection objectForKey:@"ECRRefNum"];

			NSString *token = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_TOKEN];
			self.tokenData = [[HpsTokenData alloc] init];
			self.tokenData.tokenValue = token;


			self.cardBin = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_CARD_BIN];
            self.programType = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_PROGRAM_TYPE];
			self.signatureStatus = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_SIGNATURE_STATUS];
            self.pinEntryStatus = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_PIN_ENTRY_STATUS];
            self.printLine1 = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_PRINT_LINE_1];
            self.printLine2 = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_PRINT_LINE_2];
            self.printLine3 = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_PRINT_LINE_3];
            self.printLine4 = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_PRINT_LINE_4];
            self.printLine5 = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_PRINT_LINE_5];

			self.applicationPrefferedName = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_APPLICATION_PREFERRED_NAME];
			self.applicationName = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_APPLICATION_LABEL];
			self.applicationId = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_APPLICATION_ID];
			self.applicationCryptogramType = TC;
			self.applicationCrytptogram = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_TRANSACTION_CERTIFICATE];
			self.cardHolderVerificationMethod = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_CUSTOMER_VERIFICATION_METHOD];
			self.terminalVerficationResult = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_TERMINAL_VERIFICATION_RESULTS];
            self.transactionStatusInformation = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_TRANSACTION_STATUS_INFORMATION];
		}
        if (self.transactionType != nil) {
            self.transactionType = [self mapTransactionType:self.transactionType];
        }
	} @catch (NSException *exception) {
		NSLog(@"Error on mapResponse");
	}
}

- (NSString*) mapTransactionType:(NSString *)txnType{
    
    switch([txnType integerValue]) {
        case 01:
            return PAX_TRANSACTION_TYPE_toString[SALE];
        case 02:
            return PAX_TRANSACTION_TYPE_toString[RETURN];
        default:
            return self.transactionType;
            
    }
}

@end
