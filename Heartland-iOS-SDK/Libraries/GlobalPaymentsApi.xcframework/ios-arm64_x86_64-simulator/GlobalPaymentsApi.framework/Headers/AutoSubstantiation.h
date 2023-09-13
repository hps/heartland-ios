//
//  AutoSubstantiation.h
//  GlobalPaymentsApi
//


typedef enum {
    TOTAL_HEALTHCARE_AMT = 0,
    SUBTOTAL_PRESCRIPTION_AMT = 1,
    SUBTOTAL_VISION__OPTICAL_AMT = 2,
    SUBTOTAL_CLINIC_OR_OTHER_AMT = 3,
    SUBTOTAL_DENTAL_AMT = 4
} AutoSubstantiationType;

@interface AutoSubstantiation : NSObject

@property (nonatomic, assign) NSNumber* realTimeSubstantiation;
@property (nonatomic, assign) NSString* merchantVerificationValue;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *amounts;

-(BOOL) isRealTimeSubstantiation;
-(void) setVisionSubTotal:(NSDecimalNumber *)value;
-(void) setClinicSubTotal:(NSDecimalNumber *)value;
-(void) setDentalSubTotal:(NSDecimalNumber *)value;
-(void) setPrescriptionSubTotal:(NSDecimalNumber *)value;

@end
