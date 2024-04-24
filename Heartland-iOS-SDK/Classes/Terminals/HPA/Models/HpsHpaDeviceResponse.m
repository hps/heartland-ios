#import "HpsHpaDeviceResponse.h"

@implementation HpsHpaDeviceResponse

- (id)initWithHpaDeviceResponse:(NSData *)data withParameters:(NSArray *)messageIds{

	if (self = [super initWithHpaBaseResponse:data withParameters:messageIds])
	{
		//recipt data start
		self.transactionType = self.receivedResponse.Response;
		self.applicationName = self.receivedResponse.EMV_ApplicationName;
		self.maskedCardNumber = self.receivedResponse.MaskedPAN;
		self.applicationId = self.receivedResponse.EMV_AID;
		self.applicationCrytptogram = self.receivedResponse.EMV_Cryptogram;
		if (self.receivedResponse.EMV_CryptogramType) {
			self.applicationCryptogramTypeS = self.receivedResponse.EMV_CryptogramType;
		}
		self.entryMethod = self.receivedResponse.CardAcquisition;
			//expiration date is missing for print
		self.approvalCode = self.receivedResponse.ApprovalCode;

        NSDecimal transactionAmount = [[NSDecimalNumber decimalNumberWithString:self.receivedResponse.AuthorizedAmount] decimalValue];
        NSDecimal adjustedTransactionAmount;
        NSDecimalMultiplyByPowerOf10(&adjustedTransactionAmount, &transactionAmount, -2, NSRoundDown);
        self.transactionAmount = [NSDecimalNumber decimalNumberWithDecimal:adjustedTransactionAmount];
        NSDecimal balanceDueAmount = [[NSDecimalNumber decimalNumberWithString:self.receivedResponse.BalanceDueAmount] decimalValue];
        NSDecimal adjustedBalanceDueAmount;
        NSDecimalMultiplyByPowerOf10(&adjustedBalanceDueAmount, &balanceDueAmount, -2, NSRoundDown);
        self.amountDue = [NSDecimalNumber decimalNumberWithDecimal:adjustedBalanceDueAmount];
		self.cardHolderVerificationMethod = self.receivedResponse.EMV_TSI;
		self.signatureStatus = self.receivedResponse.SignatureLine;
        self.responseCode = self.receivedResponse.ResponseCode;
		self.responseText = self.receivedResponse.ResponseText;
	if (self.receivedResponse.ResponseText)
		{
		self.deviceResponseMessage = self.receivedResponse.ResponseText;

		}
	else{
		self.deviceResponseMessage = self.receivedResponse.ResultText;
		
	}
	if (self.receivedResponse.ResponseCode)
		{
		self.deviceResponseCode = [self NormalizeResponse:self.receivedResponse.ResponseCode];
		}
	else
		{
		self.deviceResponseCode = [self NormalizeResponse:self.receivedResponse.Result] ;
		}
		//recipt data end

		self.terminalVerficationResult = self.receivedResponse.EMV_TVR;
		self.avsResultCode = self.receivedResponse.AVS;
		self.avsResultText = self.avsResultText;
        NSDecimal balanceAmount = [[NSDecimalNumber decimalNumberWithString:self.receivedResponse.AvailableBalance] decimalValue];
        NSDecimal adjustedBalanceAmount;
        NSDecimalMultiplyByPowerOf10(&adjustedBalanceAmount, &balanceAmount, -2, NSRoundDown);
        self.balanceAmount = [NSDecimalNumber decimalNumberWithDecimal:adjustedBalanceAmount];
		self.cardholderName = self.receivedResponse.CardholderName;
		self.cvvResponseCode = self.receivedResponse.CVV;
		self.cvvResponseText = self.receivedResponse.CVVResultText;
		self.entryMode = self.receivedResponse.CardAcquisition.intValue;
		self.paymentType = self.receivedResponse.CardType;
		self.terminalRefNumber = self.receivedResponse.ReferenceNumber;
		self.storedResponse = [self.receivedResponse.StoredResponse intValue] == 1 ? YES : NO ;
        self.issuerRspCode = self.receivedResponse.GatewayRspCode;
        self.issuerRspMsg = self.receivedResponse.GatewayRspMsg;
        self.authCode = self.receivedResponse.AuthCode;
        self.authCodeData = self.receivedResponse.AuthCodeData;
        self.surchargeFee = self.receivedResponse.SurchargeFee;
        self.surchargeAmount = self.receivedResponse.SurchargeAmount;
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
