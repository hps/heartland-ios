#import <Foundation/Foundation.h>
#import "NSObject+ObjectMap.h"
#import "Record.h"
#import "CardSummaryRecord.h"
#import "TransactionSummaryRecord.h"
#import "HpsLastResponse.h"
#import "HpsTerminalResponse.h"
#import "HpsDeviceProtocols.h"
#import "JsonDoc.h"
#import "HpsTransactionDuplicate.h"

@interface HpsUpaResponse : HpsTerminalResponse<IHPSDeviceResponse>

@property (nonatomic,strong) NSString *ecrId;
@property (nonatomic,strong) NSString *transactionTime;
@property (nonatomic,strong) NSString *storeAndForward;
@property (nonatomic,strong) NSString *referenceNumber;
@property (nonatomic,strong) NSString *ebtType;
@property (nonatomic,strong) NSString *clearPAN;
@property (nonatomic,strong) NSString *trackNumber;
@property (nonatomic,strong) NSString *trackData;
@property (nonatomic,strong) NSString *maskedPAN;
@property (nonatomic,strong) NSString *emvTSI;
@property (nonatomic,strong) NSString *emvTVR;
@property (nonatomic,strong) NSString *avs;
@property (nonatomic,strong) NSString *authorizedAmount;
@property (nonatomic,strong) NSString *cvv;
@property (nonatomic,strong) NSString *partialApproval;
@property (nonatomic,strong) NSString *balanceDueAmount;
@property (nonatomic,strong) NSString *availableBalance;
@property (nonatomic,strong) NSString *batchRecordHeader;
@property (nonatomic,strong) NSString *batchDetailRecord;
@property (nonatomic,strong) NSString *duplicateTransmissionDate;
@property (nonatomic,strong) NSString *errorType;
@property (nonatomic,strong) NSString *sequenceNumber;
@property (nonatomic,strong) NSString *errorRecordType;
@property (nonatomic,strong) NSString *errorFieldNumber;
@property (nonatomic,strong) NSString *errorData;
@property (nonatomic,strong) NSString *gatewayRspCode;
@property (nonatomic,strong) NSString *invoiceNbr;
@property (nonatomic,strong) NSString *authAmount;
@property (nonatomic,strong) NSString *settleAmount;
@property (nonatomic,strong) NSString *requestAmount;
@property (nonatomic,strong) NSString *issuerRefNumber;

@property (nonatomic,strong) NSString *sipId;
@property (nonatomic,strong) NSString *response;
@property (nonatomic,strong) NSString *multipleMessage;
@property (nonatomic,strong) NSString *resultText;
@property (nonatomic,strong) NSString *responseText;
@property (nonatomic,strong) NSString *responseCode;
@property (nonatomic,strong) NSString *cardAcquisition;
@property (nonatomic,strong) NSString *signatureLine;
@property (nonatomic,strong) NSString *pinVerified;
@property (nonatomic,strong) NSString *result;
@property (nonatomic,strong) NSString *responseId;
@property (nonatomic,strong) NSString *requestId;

@property (nonatomic,strong) NSString *cvvResultText;
@property (nonatomic,strong) NSString *cardBrandTransactionId;

    //Batch
@property (nonatomic,strong) NSString *deviceId;
@property (nonatomic,strong) NSString *gatewayRspMsg;
@property (nonatomic,strong) NSString *merchantName;
@property (nonatomic,strong) NSString *siteId;
@property (nonatomic,strong) NSString *batchId;
@property (nonatomic,strong) NSString *batchSeqNbr;
@property (nonatomic,strong) NSString *batchStatus;
@property (nonatomic,strong) NSString *openUtcDT;
@property (nonatomic,strong) NSString *openTxnId;
@property (nonatomic,strong) NSString *batchTxnAmt;
@property (nonatomic,strong) NSString *batchTxnCnt;
@property (nonatomic,strong) CardSummaryRecord *cardSummaryRecord;
@property (nonatomic,strong) TransactionSummaryRecord *transactionSummaryRecord;
@property (nonatomic,strong) HpsLastResponse *lastResponse;

// New Duplicate object
@property (nonatomic, strong) HpsTransactionDuplicate *duplicate;

    //EOD
@property (nonatomic,strong) NSString *reversal;
@property (nonatomic,strong) NSString *emvOfflineDecline;
@property (nonatomic,strong) NSString *transactionCertificate;
@property (nonatomic,strong) NSString *attachment;
@property (nonatomic,strong) NSString *sendSAF;
@property (nonatomic,strong) NSString *batchClose;
@property (nonatomic,strong) NSString *heartBeat;
@property (nonatomic,strong) NSString *emvPDL;

-(id)initWithJSONDoc:(JsonDoc*)data;


@property (nonatomic,strong) NSString *deviceSerialNumber;
@property (nonatomic,strong) NSString *upaAppVersion;
@property (nonatomic,strong) NSString *upaOsVersion;
@property (nonatomic,strong) NSString *upaEmvSdkVersion;
@property (nonatomic,strong) NSString *upaContactlessSdkVersion;

- (BOOL)isSuccess;
- (NSString *)duplicateTransactionId;
- (BOOL)isDuplicateTransactionError;
- (BOOL)isHostCommunicationError;
- (NSError *)responseError;

@end
