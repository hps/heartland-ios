
#import <Foundation/Foundation.h>
#import "HpsHpaBatchResponse.h"
#import "HpsHpaSafResponse.h"
#import "HpsHpaHeartBeatResponse.h"
#import "HpsHpaDeviceResponse.h"


@interface HpsHpaEodResponse : NSObject

@property (nonatomic,strong) NSString *deviceId;
@property (nonatomic,strong) NSString *transactionId;
@property (nonatomic,strong) NSString *responseCode;
@property (nonatomic,strong) NSString *responseText;
@property (nonatomic,strong) NSString *reversals;
@property (nonatomic,strong) NSString *offlineDecline;
@property (nonatomic,strong) NSString *transactionCertificate;
@property (nonatomic,strong) NSString *addAttachment;
@property (nonatomic,strong) NSString *sendSAF;
@property (nonatomic,strong) NSString *batchClose;
@property (nonatomic,strong) NSString *emvpdl;
@property (nonatomic,strong) NSString *heartBeat;
@property (nonatomic,strong) HpsHpaDeviceResponse *reversalResponse;
@property (nonatomic,strong) HpsHpaDeviceResponse *eMVOfflineDeclineResponse;
@property (nonatomic,strong) HpsHpaDeviceResponse *eMVTCResponse;
@property (nonatomic,strong) HpsHpaDeviceResponse *batchCloseResponse;
@property (nonatomic,strong) HpsHpaDeviceResponse *eMVPDLResponse;
@property (nonatomic,strong) HpsHpaDeviceResponse *attachmentResponse;

@property (nonatomic,strong) HpsHpaBatchResponse *hpsHpaBatchResponse;
@property (nonatomic,strong) HpsHpaSafResponse *hpsHpaSafResponse;
@property (nonatomic,strong) HpsHpaHeartBeatResponse *hpsHpaHeartBeatResponse;

-(id)initWithHpaEodResponse:(NSData *)data;


@end


