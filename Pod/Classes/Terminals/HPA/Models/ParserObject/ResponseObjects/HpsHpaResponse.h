#import <Foundation/Foundation.h>
#import "NSObject+ObjectMap.h"
#import "Record.h"
#import "CardSummaryRecord.h"
#import "TransactionSummaryRecord.h"
#import "HpsLastResponse.h"

@protocol HpaResposeInterface

@property (readonly,retain) NSString *Version;
@property (readonly,retain) NSString *ECRId;
@property (readonly,retain) NSString *TransactionTime;
@property (readonly,retain) NSString *StoreAndForward;
@property (readonly,retain) NSString *ReferenceNumber;
@property (readonly,retain) NSString *CardType;
@property (readonly,retain) NSString *EBTType;
@property (readonly,retain) NSString *ResponseText;
@property (readonly,retain) NSString *ClearPAN;
@property (readonly,retain) NSString *TrackNumber;
@property (readonly,retain) NSString *TrackData;
@property (readonly,retain) NSString *MaskedPAN;
@property (readonly,retain) NSString *EMV_AID;
@property (readonly,retain) NSString *EMV_ApplicationName;
@property (readonly,retain) NSString *EMV_Cryptogram;
@property (readonly,retain) NSString *EMV_CryptogramType;
@property (readonly,retain) NSString *EMV_TSI;
@property (readonly,retain) NSString *EMV_TVR;
@property (readonly,retain) NSString *AVS;
@property (readonly,retain) NSString *AuthorizedAmount;
@property (readonly,retain) NSString *CVV;
@property (readonly,retain) NSString *PartialApproval;
@property (readonly,retain) NSString *BalanceDueAmount;
@property (readonly,retain) NSString *AvailableBalance;
@property (readonly,retain) NSString *BatchRecordHeader;
@property (readonly,retain) NSString *BatchDetailRecord;
@property (readonly,retain) NSString *DuplicateTransmissionDate;
@property (readonly,retain) NSString *ErrorType;
@property (readonly,retain) NSString *SequenceNumber;
@property (readonly,retain) NSString *ErrorRecordType;
@property (readonly,retain) NSString *ErrorFieldNumber;
@property (readonly,retain) NSString *ErrorData;
@property (readonly,retain) NSString *GatewayRspCode;
@property (readonly,retain) NSString *InvoiceNbr;
@property (readonly,retain) NSString *AuthAmount;
@property (readonly,retain) NSString *SettleAmount;
@property (readonly,retain) NSString *RequestAmount;
@property (readonly,retain) NSString *StoredResponse;

@property (readonly,retain) NSString *SIPId;
@property (readonly,retain) NSString *Response;
@property (readonly,retain) NSString *MultipleMessage;
@property (readonly,retain) NSString *ResultText;
@property (readonly,retain) NSString *ResponseCode;
@property (readonly,retain) NSString *Status;
@property (readonly,retain) NSString *ApprovalCode;
@property (readonly,retain) NSString *CardAcquisition;
@property (readonly,retain) NSString *SignatureLine;
@property (readonly,retain) NSString *PINVerified;
@property (readonly,retain) NSString *Result;
@property (readonly,retain) NSString *TransactionId;
@property (readonly,retain) NSString *ResponseId;
@property (readonly,retain) NSString *RequestId;
@property (readonly,retain) Record *Record;

@property (readonly,retain) NSString *CVVResultText;

	//Batch
@property (readonly,retain) NSString *DeviceId;
@property (readonly,retain) NSString *GatewayRspMsg;
@property (readonly,retain) NSString *MerchantName;
@property (readonly,retain) NSString *SiteId;
@property (readonly,retain) NSString *BatchId;
@property (readonly,retain) NSString *BatchSeqNbr;
@property (readonly,retain) NSString *BatchStatus;
@property (readonly,retain) NSString *OpenUtcDT;
@property (readonly,retain) NSString *OpenTxnId;
@property (readonly,retain) NSString *BatchTxnAmt;
@property (readonly,retain) NSString *BatchTxnCnt;
@property (readonly,retain) CardSummaryRecord *CardSummaryRecord;
@property (readonly,retain) TransactionSummaryRecord *TransactionSummaryRecord;
@property (readonly,retain) NSString *CardholderName;
@property (readonly,retain) HpsLastResponse *LastResponse;

    //EOD
@property (readonly,retain) NSString *Reversal;
@property (readonly,retain) NSString *EMVOfflineDecline;
@property (readonly,retain) NSString *TransactionCertificate;
@property (readonly,retain) NSString *Attachment;
@property (readonly,retain) NSString *SendSAF;
@property (readonly,retain) NSString *BatchClose;
@property (readonly,retain) NSString *HeartBeat;
@property (readonly,retain) NSString *EMVPDL;

@end

@interface HpsHpaResponse : NSObject<HpaResposeInterface>

@property (readonly,retain) NSString *Version;
@property (readonly,retain) NSString *ECRId;
@property (readonly,retain) NSString *TransactionTime;
@property (readonly,retain) NSString *StoreAndForward;
@property (readonly,retain) NSString *ReferenceNumber;
@property (readonly,retain) NSString *CardType;
@property (readonly,retain) NSString *EBTType;
@property (readonly,retain) NSString *ResponseText;
@property (readonly,retain) NSString *ClearPAN;
@property (readonly,retain) NSString *TrackNumber;
@property (readonly,retain) NSString *TrackData;
@property (readonly,retain) NSString *MaskedPAN;
@property (readonly,retain) NSString *EMV_AID;
@property (readonly,retain) NSString *EMV_ApplicationName;
@property (readonly,retain) NSString *EMV_Cryptogram;
@property (readonly,retain) NSString *EMV_CryptogramType;
@property (readonly,retain) NSString *EMV_TSI;
@property (readonly,retain) NSString *EMV_TVR;
@property (readonly,retain) NSString *AVS;
@property (readonly,retain) NSString *AuthorizedAmount;
@property (readonly,retain) NSString *CVV;
@property (readonly,retain) NSString *CVVResultText;
@property (readonly,retain) NSString *PartialApproval;
@property (readonly,retain) NSString *BalanceDueAmount;
@property (readonly,retain) NSString *AvailableBalance;
@property (readonly,retain) NSString *BatchRecordHeader;
@property (readonly,retain) NSString *BatchDetailRecord;
@property (readonly,retain) NSString *DuplicateTransmissionDate;
@property (readonly,retain) NSString *ErrorType;
@property (readonly,retain) NSString *SequenceNumber;
@property (readonly,retain) NSString *ErrorRecordType;
@property (readonly,retain) NSString *ErrorFieldNumber;
@property (readonly,retain) NSString *ErrorData;
@property (readonly,retain) NSString *GatewayRspCode;
@property (readonly,retain) NSString *InvoiceNbr;
@property (readonly,retain) NSString *AuthAmount;
@property (readonly,retain) NSString *SettleAmount;
@property (readonly,retain) NSString *RequestAmount;
@property (readonly,retain) NSString *StoredResponse;

@property (readonly,retain) NSString *SIPId;
@property (readonly,retain) NSString *Response;
@property (readonly,retain) NSString *MultipleMessage;
@property (readonly,retain) NSString *ResultText;
@property (readonly,retain) NSString *ResponseCode;
@property (readonly,retain) NSString *Status;
@property (readonly,retain) NSString *ApprovalCode;
@property (readonly,retain) NSString *CardAcquisition;
@property (readonly,retain) NSString *SignatureLine;
@property (readonly,retain) NSString *PINVerified;
@property (readonly,retain) NSString *Result;
@property (readonly,retain) NSString *TransactionId;
@property (readonly,retain) NSString *ResponseId;
@property (readonly,retain) NSString *RequestId;
@property (readonly,retain) Record *Record;
@property (readonly,retain) HpsLastResponse *LastResponse;

	//Batch
@property (readonly,retain) NSString *DeviceId;
@property (readonly,retain) NSString *GatewayRspMsg;
@property (readonly,retain) NSString *MerchantName;
@property (readonly,retain) NSString *SiteId;
@property (readonly,retain) NSString *BatchId;
@property (readonly,retain) NSString *BatchSeqNbr;
@property (readonly,retain) NSString *BatchStatus;
@property (readonly,retain) NSString *OpenUtcDT;
@property (readonly,retain) NSString *OpenTxnId;
@property (readonly,retain) NSString *BatchTxnAmt;
@property (readonly,retain) NSString *BatchTxnCnt;
@property (readonly,retain) CardSummaryRecord *CardSummaryRecord;
@property (readonly,retain) TransactionSummaryRecord *TransactionSummaryRecord;
@property (readonly,retain) NSString *CardholderName;


    //EOD
@property (readonly,retain) NSString *Reversal;
@property (readonly,retain) NSString *EMVOfflineDecline;
@property (readonly,retain) NSString *TransactionCertificate;
@property (readonly,retain) NSString *Attachment;
@property (readonly,retain) NSString *SendSAF;
@property (readonly,retain) NSString *BatchClose;
@property (readonly,retain) NSString *HeartBeat;
@property (readonly,retain) NSString *EMVPDL;
-(id)initWithXMLData:(NSData *)data withSetRecord:(BOOL)value;

@end
