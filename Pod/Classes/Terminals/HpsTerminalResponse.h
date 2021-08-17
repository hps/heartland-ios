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
@property (nonatomic,strong) NSString *responseText;
@property (nonatomic,strong) NSString *transactionId;
@property (nonatomic,strong) NSString *terminalRefNumber;
@property (nonatomic,strong) HpsTokenData *tokenData;
@property (nonatomic,strong) NSString *signatureStatus;
#pragma mark - TRANSACTIONAL
@property (nonatomic,strong) NSString *transactionType;
@property (nonatomic,strong) NSString *entryMethod;

@property (nonatomic,strong) NSString *maskedCardNumber;
@property (nonatomic) int entryMode;                //authrizationCode missing
@property (nonatomic,strong) NSString *approvalCode;

@property (nonatomic,strong) NSNumber *transactionAmount;
@property (nonatomic,strong) NSNumber *amountDue;
@property (nonatomic,strong) NSNumber *balanceAmount;

@property (nonatomic,strong) NSString *cardHolderName;
@property (nonatomic,strong) NSString *cardBin;
@property (nonatomic) bool cardPresent;
@property (nonatomic,strong) NSString *expirationDate;
@property (nonatomic,strong) NSNumber *tipAmount;
@property (nonatomic,strong) NSNumber *cashBackAmount;
@property (nonatomic,strong) NSString *avsResultCode;
@property (nonatomic,strong) NSString *avsResultText;
@property (nonatomic,strong) NSString *cvvResponseCode;
@property (nonatomic,strong) NSString *cvvResponseText;
@property (nonatomic) BOOL taxExept;
@property (nonatomic,strong) NSString *taxExeptId;
@property (nonatomic,strong) NSString *paymentType; //ticket number missing

@property (nonatomic,strong) NSNumber *approvedAmount;
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
@property (nonatomic,strong) NSString *transactionStatusInformation;

- (void) mapResponse:(id <HpaResposeInterface>) response;

@end
