//  Copyright (c) 2016 Heartland Payment Systems. All rights reserved.

#import <Foundation/Foundation.h>
#import "HpsDeviceProtocols.h"
#import "HpsTokenData.h"
#import "HpsTerminalEnums.h"
#import "HpsPaxHostResponse.h"

@interface HpsTerminalResponse : NSObject

@property (nonatomic,strong) NSNumber *transactionAmount;
@property (nonatomic,strong) NSNumber *approvedAmount;
@property (nonatomic,strong) NSNumber *amountDue;
@property (nonatomic,strong) NSNumber *tipAmount;
@property (nonatomic,strong) NSNumber *cashBackAmount;
@property (nonatomic,strong) NSString *transactionType;
@property (nonatomic,strong) NSString *approvalCode;
@property (nonatomic,strong) NSString *responseText;
@property (nonatomic,readwrite) int transactionId;

//Functional
@property (nonatomic,strong) NSString *terminalRefNumber;


//Account
@property (nonatomic,strong) NSString *maskedCardNumber;
@property (nonatomic) int entryMode;
@property (nonatomic,strong) NSString *expirationDate;
@property (nonatomic,strong) NSString *paymentType;
@property (nonatomic,strong) NSString *cardHolderName;
@property (nonatomic,strong) NSString *cvvResponseCode;
@property (nonatomic,strong) NSString *cvvResponseText;
@property (nonatomic) bool cardPresent;

//AVS
@property (nonatomic,strong) NSString *avsResultCode;
@property (nonatomic,strong) NSString *avsResultText;

//Comercial

@property (nonatomic) BOOL taxExept;
@property (nonatomic,strong) NSString *taxExeptId;

//ext
@property (nonatomic,strong) HpsTokenData *tokenData;

@property (nonatomic,strong) NSString *cardBin;
@property (nonatomic,strong) NSString *signatureStatus;

//emv
@property (nonatomic,strong) NSString *applicationPrefferedName;
@property (nonatomic,strong) NSString *applicationName;
@property (nonatomic,strong) NSString *applicationId;
@property (nonatomic,strong) NSString *applicationCrytptogram;
@property (nonatomic,strong) NSString *cardHolderVerificationMethod;
@property (nonatomic,strong) NSString *terminalVerficationResult;
@property (nonatomic) ApplicationCrytogramType applicationCryptogramType;

@property (nonatomic,strong) HpsPaxHostResponse *hostResponse;

@end
