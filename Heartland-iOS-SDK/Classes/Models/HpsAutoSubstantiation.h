//
//  HpsAutoSubstantiation.h
//  Heartland-iOS-SDK
//

@interface HpsAutoSubstantiation : NSObject

@property (nonatomic, assign) NSNumber* realTimeSubstantiation;
@property (nonatomic, assign) NSString* merchantVerificationValue;
@property (readonly, strong) NSMutableDictionary<NSString *, NSString *> *amounts;

-(NSMutableDictionary<NSString *, NSString *> *) getAmounts;
-(BOOL) isRealTimeSubstantiation;
-(void) setVisionSubTotal:(NSDecimalNumber *)value;
-(void) setClinicSubTotal:(NSDecimalNumber *)value;
-(void) setDentalSubTotal:(NSDecimalNumber *)value;
-(void) setPrescriptionSubTotal:(NSDecimalNumber *)value;

@end
