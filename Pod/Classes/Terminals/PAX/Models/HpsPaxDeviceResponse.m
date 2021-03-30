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
		}
		if (self.amountResponse != nil){
			self.transactionAmount = [NSNumber numberWithDouble:self.amountResponse.approvedAmount];
			self.amountDue = [NSNumber numberWithDouble:self.amountResponse.amountDue];
			self.tipAmount = [NSNumber numberWithDouble:self.amountResponse.tipAmount];
			self.cashBackAmount = [NSNumber numberWithDouble:self.amountResponse.cashBackAmount];
            self.merchantFee = [NSNumber numberWithDouble:self.amountResponse.merchantFee];
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
			self.transactionId = [[self.extDataResponse.collection objectForKey:PAX_EXT_DATA_HOST_REFERENCE_NUMBER] intValue];

			NSString *token = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_TOKEN];
			self.tokenData = [[HpsTokenData alloc] init];
			self.tokenData.tokenValue = token;


			self.cardBin = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_CARD_BIN];
			self.signatureStatus = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_SIGNATURE_STATUS];

			self.applicationPrefferedName = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_APPLICATION_PREFERRED_NAME];
			self.applicationName = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_APPLICATION_LABEL];
			self.applicationId = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_APPLICATION_ID];
			self.applicationCryptogramType = TC;
			self.applicationCrytptogram = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_TRANSACTION_CERTIFICATE];
			self.cardHolderVerificationMethod = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_CUSTOMER_VERIFICATION_METHOD];
			self.terminalVerficationResult = [self.extDataResponse.collection objectForKey:PAX_EXT_DATA_TERMINAL_VERIFICATION_RESULTS];

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
