
#import "HpsHpaSendFileBuilder.h"
#import "HpsHpaRequest.h"
#import "HpaFileUpload.h"

@interface HpsHpaSendFileBuilder ()
@property (nonatomic, strong) NSNumber *version;
@property (nonatomic, strong) NSString *ecrId;
@end

@implementation HpsHpaSendFileBuilder
- (id) initWithDevice: (HpsHpaDevice*)HpaDevice{
    self = [super init];
    if (self != nil)
    {
        device = HpaDevice;
        self.version = [NSNumber numberWithDouble:1.0];
        self.ecrId = @"1004";
    }
    return self;
}

- (void) executeSendFileNameRequest:(void(^)(id<IHPSDeviceResponse>, NSError*))responseBlock{
    
    
    NSLog(@"Execute SendFileName Request....");
    HpaFileUpload *file = [[HpaFileUpload alloc]initWithFilePath:self.filePath];
    
   HpsHpaRequest *request_sendFileName = [[HpsHpaRequest alloc]initToSendFileNameWithVersion:(self.version.stringValue ? self.version.stringValue :@"1.0") withEcrId:(self.ecrId ? self.ecrId :@"1004") withRequest:HPA_MSG_ID_toString[SEND_FILE] withFileName:file.fileName withFileSize:file.fileSize andMultipleMessage:@"1"];
    
    request_sendFileName.RequestId = self.referenceNumber;
    
    [device processTransactionWithRequest:request_sendFileName withResponseBlock:^(id<IHPSDeviceResponse> response, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             responseBlock(response, error);
         });
     }];
    
}

- (void) executeSendFileDataRequest:(void(^)(id<IHPSDeviceResponse>, NSError*))responseBlock{
    
    NSLog(@"Execute SendFileData Request....");
    HpaFileUpload *file = [[HpaFileUpload alloc]initWithFilePath:self.filePath];
    HpsHpaRequest *request_SendFileData = [[HpsHpaRequest alloc]initToSendFileDataWithVersion:(self.version.stringValue ? self.version.stringValue :@"1.0") withEcrId:(self.ecrId ? self.ecrId :@"1004") withRequest:HPA_MSG_ID_toString[SEND_FILE] withFileData:file.hexData andMultipleMessage:@"0"];
    
    request_SendFileData.RequestId = self.referenceNumber;
    
    [device processTransactionWithRequest:request_SendFileData withResponseBlock:^(id<IHPSDeviceResponse> response, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             responseBlock(response, error);
         });
     }];
    
}
@end
