#import <Foundation/Foundation.h>
#import "HpsDeviceProtocols.h"
#import "HpsTokenData.h"
#import "HpsTerminalEnums.h"
#import "HpsPaxHostResponse.h"
#import "HpsHpaResponse.h"

@class HpsHpaResponse;

@interface HpsTerminalResponse : NSObject

#pragma mark - INTERNAL
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *command;
@property (nonatomic,strong) NSString *version;
#pragma mark - FUNCTIONAL
@property (nonatomic,strong) NSString *deviceResponseCode;

@property (nonatomic,strong) NSString *deviceResponseMessage;
@property (nonatomic,strong) NSString *responseCode;
@property (nonatomic,strong) NSString *responseText;
@property (nonatomic,strong) NSString *transactionId;
@property (nonatomic,strong) NSString *terminalRefNumber;
@property (nonatomic,strong) HpsTokenData *tokenData;
@property (nonatomic,strong) NSString *signatureStatus;
@property (nonatomic,readonly) BOOL gmsResponseIsApproval;
@property (nonatomic,readonly) BOOL gmsResponseIsPartialApproval;
@property (nonatomic,readonly) BOOL gmsResponseIsReversible;
@property (nonatomic,readonly) BOOL gmsResponseIsTimeout;
@property (nonatomic,readonly) BOOL gmsResponseIsDuplicate;
@property (nonatomic,readonly) NSString *gmsResponseDuplicatedTransactionID;
@property (nonatomic, strong) NSString *issuerRspCode;
@property (nonatomic, strong) NSString *issuerRspMsg;
@property (nonatomic, strong) NSString *authCode;
@property (nonatomic, strong) NSString *authCodeData;
#pragma mark - TRANSACTIONAL
@property (nonatomic,strong) NSString *transactionType;
@property (nonatomic,strong) NSString *entryMethod;

@property (nonatomic,strong) NSString *maskedCardNumber;
@property (nonatomic) int entryMode;
@property (nonatomic,strong) NSString *approvalCode;

@property (nonatomic,strong) NSDecimalNumber *transactionAmount;
@property (nonatomic,strong) NSDecimalNumber *amountDue;
@property (nonatomic,strong) NSDecimalNumber *balanceAmount;

@property (nonatomic,strong) NSString *cardholderName;
@property (nonatomic,strong) NSString *cardBin;
@property (nonatomic,strong) NSString *programType;
@property (nonatomic) bool cardPresent;
@property (nonatomic,strong) NSString *expirationDate;
@property (nonatomic,strong) NSDecimalNumber *tipAmount;
@property (nonatomic,strong) NSDecimalNumber *cashBackAmount;
@property (nonatomic,strong) NSString *avsResultCode;
@property (nonatomic,strong) NSString *avsResultText;
@property (nonatomic,strong) NSString *cvvResponseCode;
@property (nonatomic,strong) NSString *cvvResponseText;
@property (nonatomic) BOOL taxExept;
@property (nonatomic,strong) NSString *taxExeptId;
@property (nonatomic,strong) NSString *paymentType; //ticket number missing
@property (nonatomic,strong) NSDecimalNumber *merchantFee;

@property (nonatomic,strong) NSDecimalNumber *approvedAmount;
@property (nonatomic,strong) HpsPaxHostResponse *hostResponse;
#pragma mark - EMV
@property (nonatomic,strong) NSString *applicationPrefferedName;
@property (nonatomic,strong) NSString *applicationName;
@property (nonatomic,strong) NSString *applicationId;
@property (nonatomic,strong) NSString *applicationCrytptogram;
@property (nonatomic) ApplicationCrytogramType applicationCryptogramType;
@property (nonatomic) NSString *applicationCryptogramTypeS;

@property (nonatomic,strong) NSString *cardHolderVerificationMethod;
@property (nonatomic,strong) NSString *terminalVerficationResult;
@property (nonatomic,strong) NSString *terminalSerialNumber;
@property (nonatomic) BOOL storedResponse;
@property (nonatomic,readwrite) NSString *lastResponseTransactionId;

@property (nonatomic,strong) NSString *clientTransactionId;
@property (nonatomic,strong) NSString *transactionStatusInformation;
@property (nonatomic,strong) NSString *cardType;
@property (nonatomic,strong) NSString *cardBrandTransactionId;
@property (nonatomic,strong) NSString *signatureData;
@property (nonatomic,strong) NSString *surchargeFee;

- (void) mapResponse:(id <HpaResposeInterface>) response;
// @todo
//+(HpsTerminalResponse*)terminalResponseFromVitalSDK:(TransactionResponse*)transactionResponse;

@end
