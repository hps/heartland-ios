#import "HpsHpaDiagnosticBuilder.h"

@interface HpsHpaDiagnosticBuilder ()

@property (nonatomic, strong) NSNumber *version;
@property (nonatomic, strong) NSString *ecrId;

@end

@implementation HpsHpaDiagnosticBuilder

- (id)initWithDevice: (HpsHpaDevice*)HpaDevice{
    self = [super init];
    if (self != nil)
    {
        device = HpaDevice;
        self.version = [NSNumber numberWithDouble:1.0];
        self.ecrId = @"1004";
    }
    return self;
}

- (void) execute:(void(^)(HpsHpaDiagnosticResponse*, NSError*))responseBlock {
    
    NSLog(@"Execute Get Diagnostic Report....");
    
    HpsHpaRequest *request_auth = [[HpsHpaRequest alloc]
                                   initToGetDiagnosticReport:(self.version.stringValue ? self.version.stringValue : @"1.0") withEcrId:(self.ecrId?self.ecrId:@"1004") withFieldCount:@"10" andRequest:HPA_MSG_ID_toString[GET_DIAGNOSTIC_REPORT]];    
    request_auth.RequestId = self.referenceNumber;
    
    [device getDiagnosticReport:request_auth withResponseBlock:^(HpsHpaDiagnosticResponse* respose, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             responseBlock(respose, error);
         });
     }];
}

@end
