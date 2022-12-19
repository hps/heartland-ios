#import "HpsHpaEodResponse.h"
#import "HpsHpaParser.h"


#define SHARED_PARAMS [HpsHpaSharedParams getInstance]
@implementation HpsHpaEodResponse

-(id)initWithHpaEodResponse:(NSData *)data
{
    self = [super init];
    
    self.hpsHpaBatchResponse = [[HpsHpaBatchResponse alloc] initWithHpaBatchResponse:nil withParameters:nil];
    self.hpsHpaSafResponse = [[HpsHpaSafResponse alloc]initWithHpaSafResponse:nil];
    self.hpsHpaHeartBeatResponse = [[HpsHpaHeartBeatResponse alloc]init];
    
    NSString *xmlString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray *arr = [xmlString componentsSeparatedByString:@"</SIP>"];
    
    for (NSString *response in arr) {
        
        id <HpaResposeInterface> responeN = [HpsHpaParser parseResponseWithXmlString:[NSString stringWithFormat:@"%@</SIP>",response]];
        
        [self mapResponse:responeN];
    }
    
    return self;
}

-(void)mapResponse:(id <HpaResposeInterface>)response {
    
    if ([response.Response isEqualToString:@"GetBatchReport"])
    {
        [self.hpsHpaBatchResponse mapResponse:response];
    }else if ([response.Response isEqualToString:@"SendSAF"])
    {
        [self.hpsHpaSafResponse mapResponse:response];
    }else if ([response.Response isEqualToString:@"Heartbeat"])
    {
        [self.hpsHpaHeartBeatResponse mapResponse:response];
    }else if ([response.Response isEqualToString:@"EOD"])
    {
                self.deviceId = response.DeviceId;
                self.transactionId = response.ResponseId;
                self.responseCode = response.Result;
                self.responseText = response.ResultText;
                        self.reversals = response.Reversal;
                        self.offlineDecline = response.EMVOfflineDecline;
                        self.transactionCertificate = response.TransactionCertificate;
                        self.addAttachment = response.Attachment;
                        self.sendSAF = response.SendSAF;
                        self.batchClose = response.BatchClose;
                        self.emvpdl = response.EMVPDL;
                        self.heartBeat = response.HeartBeat;
    }
    else
    {
        HpsHpaDeviceResponse *responeN = [[HpsHpaDeviceResponse alloc]initWithHpaDeviceResponse:nil withParameters:nil];
        [responeN mapResponse:response];
        
        if ([response.Response isEqualToString:@"Reversal"])
        {
            _reversalResponse = responeN;
        }
        else if([response.Response isEqualToString:@"EMVOfflineDecline"])
        {
             _eMVOfflineDeclineResponse = responeN;
        }
        else if([response.Response isEqualToString:@"EMVTC"])
        {
             _eMVTCResponse = responeN;
        }
        else if([response.Response isEqualToString:@"BatchClose"])
        {
             _batchCloseResponse = responeN;
        }
        else if([response.Response isEqualToString:@"EMVPDL"])
        {
             _eMVPDLResponse = responeN;
        }
        else if([response.Response isEqualToString:@"Attachment"])
        {
             _attachmentResponse = responeN;
        }
    }

}
@end
