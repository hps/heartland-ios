#import "HpsHpaEodBuilder.h"
#import "HpsHpaRequest.h"

@interface HpsHpaEodBuilder()
@property (readwrite, strong) NSNumber *version;
@property (readwrite, strong) NSString *ecrId;

@end
@implementation HpsHpaEodBuilder

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

-(void) execute:(void(^)(HpsHpaEodResponse*, NSError*))responseBlock{
    NSLog(@"Executing EOD");
    
    HpsHpaRequest *request_SAF = [[HpsHpaRequest alloc]initExecuteEODWithVersion:(self.version.stringValue ? self.version.stringValue :@"1.0") withEcrId:( self.ecrId ? self.ecrId :@"1004") andRequest:HPA_MSG_ID_toString[EXECUTE_EOD]];
    
    request_SAF.RequestId = self.referenceNumber;
    [device processEODWithRequest:request_SAF withResponseBlock:^(HpsHpaEodResponse* response, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             responseBlock(response, error);
         });
     }];
    
}
@end
