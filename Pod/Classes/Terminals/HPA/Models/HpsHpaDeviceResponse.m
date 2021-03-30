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
		self.transactionAmount = [NSNumber numberWithFloat:self.recievedResponse.AuthorizedAmount.doubleValue / 100];
		self.amountDue = [NSNumber numberWithInteger:self.recievedResponse.BalanceDueAmount.doubleValue /100];
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
		self.balanceAmount = [NSNumber numberWithInteger:self.recievedResponse.AvailableBalance.doubleValue /100];
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
