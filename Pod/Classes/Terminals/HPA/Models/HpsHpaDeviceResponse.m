#import "HpsHpaDeviceResponse.h"

@implementation HpsHpaDeviceResponse

- (id)initWithHpaDeviceResponse:(NSData *)data withParameters:(NSArray *)messageIds{

	if (self = [super initWithHpaBaseResponse:data withParameters:messageIds])
	{
		//recipt data start
		self.transactionType = self.recievedResponse.Response;
		self.applicationName = self.recievedResponse.EMV_ApplicationName;
		self.maskedCardNumber = self.recievedResponse.MaskedPAN;
		self.applicationId = self.recievedResponse.EMV_AID;
		self.applicationCrytptogram = self.recievedResponse.EMV_Cryptogram;
		if (self.recievedResponse.EMV_CryptogramType) {
			self.applicationCryptogramTypeS = self.recievedResponse.EMV_CryptogramType;
		}
		self.entryMethod = self.recievedResponse.CardAcquisition;
			//expiration date is missing for print
		self.approvalCode = self.recievedResponse.ApprovalCode;

        NSDecimal transactionAmount = [[NSDecimalNumber decimalNumberWithString:self.recievedResponse.AuthorizedAmount] decimalValue];
        NSDecimal adjustedTransactionAmount;
        NSDecimalMultiplyByPowerOf10(&adjustedTransactionAmount, &transactionAmount, -2, NSRoundDown);
        self.transactionAmount = [NSDecimalNumber decimalNumberWithDecimal:adjustedTransactionAmount];
        NSDecimal balanceDueAmount = [[NSDecimalNumber decimalNumberWithString:self.recievedResponse.BalanceDueAmount] decimalValue];
        NSDecimal adjustedBalanceDueAmount;
        NSDecimalMultiplyByPowerOf10(&adjustedBalanceDueAmount, &balanceDueAmount, -2, NSRoundDown);
        self.amountDue = [NSDecimalNumber decimalNumberWithDecimal:adjustedBalanceDueAmount];
		self.cardHolderVerificationMethod = self.recievedResponse.EMV_TSI;
		self.signatureStatus = self.recievedResponse.SignatureLine;
		self.responseText = self.recievedResponse.ResponseText;
	if (self.recievedResponse.ResponseText)
		{
		self.deviceResponseMessage = self.recievedResponse.ResponseText;

		}
	else{
		self.deviceResponseMessage = self.recievedResponse.ResultText;
		
	}
	if (self.recievedResponse.ResponseCode)
		{
		self.deviceResponseCode = [self NormalizeResponse:self.recievedResponse.ResponseCode];
		}
	else
		{
		self.deviceResponseCode = [self NormalizeResponse:self.recievedResponse.Result] ;
		}
		//recipt data end

		self.terminalVerficationResult = self.recievedResponse.EMV_TVR;
		self.avsResultCode = self.recievedResponse.AVS;
		self.avsResultText = self.avsResultText;
        NSDecimal balanceAmount = [[NSDecimalNumber decimalNumberWithString:self.recievedResponse.AvailableBalance] decimalValue];
        NSDecimal adjustedBalanceAmount;
        NSDecimalMultiplyByPowerOf10(&adjustedBalanceAmount, &balanceAmount, -2, NSRoundDown);
        self.balanceAmount = [NSDecimalNumber decimalNumberWithDecimal:adjustedBalanceAmount];
		self.cardholderName = self.recievedResponse.CardholderName;
		self.cvvResponseCode = self.recievedResponse.CVV;
		self.cvvResponseText = self.recievedResponse.CVVResultText;
		self.entryMode = self.recievedResponse.CardAcquisition.intValue;
		self.paymentType = self.recievedResponse.CardType;
		self.terminalRefNumber = self.recievedResponse.ReferenceNumber;
		self.storedResponse = [self.recievedResponse.StoredResponse intValue] == 1 ? YES : NO ;
}

	return self;
}

-(NSString*)toString{

	return [NSString stringWithFormat:@" \n\n #### toString = \n version = %@ Device ECR ID = %@ Device SIP ID = %@ Device Response Code = %@ Device msg = %@ Device response = %@ \n\n", self.version,self.ecrId,self.hpaId,self.deviceResponseCode,self.deviceResponseMessage,self.responseText];
}

- (void) mapResponse:(id <HpaResposeInterface>) response
{
	[super mapResponse:response];
}

@end
