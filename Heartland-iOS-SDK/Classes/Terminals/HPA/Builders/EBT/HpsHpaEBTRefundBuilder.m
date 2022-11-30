#import "HpsHpaEBTRefundBuilder.h"
#import "HpsHpaRequest.h"

@interface HpsHpaEBTRefundBuilder()

@property (readwrite, strong) NSString *cardGroup;
@property (readwrite, strong) NSNumber *version;
@property (readwrite, strong) NSString *ecrId;
@property (readwrite, strong) NSNumber *confirmAmount;
@property (readwrite, strong) NSNumber *invoiceNbr;
@property (readwrite, strong) NSNumber *totalAmount;

@end
@implementation HpsHpaEBTRefundBuilder

- (id)initWithDevice: (HpsHpaDevice*)HpaDevice{
    self = [super init];
    if (self != nil)
    {
        device = HpaDevice;
        self.version = [NSNumber numberWithDouble:1.0];
        self.ecrId = @"1004";
        self.confirmAmount = [NSNumber numberWithDouble:0];
        self.cardGroup = @"EBT";
    }
    return self;
}

- (void) execute:(void(^)(id<IHPSDeviceResponse>, NSError*))responseBlock{
    
    self.totalAmount = [NSNumber numberWithFloat:(self.amount.doubleValue * 100)] ;
    self.invoiceNbr = [NSNumber numberWithInteger:self.referenceNumber];
    [self validate];
    HpsHpaRequest *request_refund = [[HpsHpaRequest alloc]initWithEBTRefundRequestwithVersion:(self.version.stringValue ? self.version.stringValue :@"1.0") withEcrId:( self.ecrId ? self.ecrId :@"1004") withRequest:HPA_MSG_ID_toString[CREDIT_REFUND] withCardGroup:self.cardGroup withConfirmAmount:(self.confirmAmount.stringValue ? self.confirmAmount.stringValue :@"0") withInvoiceNbr:self.invoiceNbr.stringValue withTotalAmount:self.totalAmount.stringValue];
    
    request_refund.RequestId = self.referenceNumber;
    
    [device processTransactionWithRequest:request_refund withResponseBlock:^(id<IHPSDeviceResponse> respose, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             responseBlock(respose, error);
         });
     }];
}

- (void) validate
{
    //    //No amount
    if (self.totalAmount == nil || self.totalAmount.doubleValue <= 0) {
        @throw [NSException exceptionWithName:@"HpsHpaException" reason:@"Amount is required." userInfo:nil];
    }
}
@end
