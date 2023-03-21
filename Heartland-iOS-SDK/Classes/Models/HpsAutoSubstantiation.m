//
//  HpsAutoSubstantiation.m
//  Heartland-iOS-SDK
//

#import <Foundation/Foundation.h>
#import "HpsAutoSubstantiation.h"

@interface HpsAutoSubstantiation ()

@property (readwrite, strong) NSMutableDictionary<NSString *, NSString *> *amounts;

@end

@implementation HpsAutoSubstantiation

-(id)init {
    if ( self = [super init] ) {
        self.amounts = [NSMutableDictionary new];
        [self.amounts setValue:@"0.00" forKey:@"TOTAL_HEALTHCARE_AMT"];
    }
    return self;
}

-(BOOL) isRealTimeSubstantiation {
    return [_realTimeSubstantiation boolValue];
}

-(void) setTotalHealthCareAmount:(NSDecimalNumber *)value {
    NSDecimalNumber *valueForTotalHealthcareAmt = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    if ([self.amounts objectForKey:@"TOTAL_HEALTHCARE_AMT"]) {
        NSString *valueForKey = [self.amounts valueForKey:@"TOTAL_HEALTHCARE_AMT"];
        if (valueForKey == nil) {
            valueForKey = @"0.00";
        }
        valueForTotalHealthcareAmt = [NSDecimalNumber decimalNumberWithString:valueForKey];
    }
    valueForTotalHealthcareAmt = [valueForTotalHealthcareAmt decimalNumberByAdding: value];
    [self.amounts setValue:[valueForTotalHealthcareAmt stringValue] forKey:@"TOTAL_HEALTHCARE_AMT"];
}

-(NSMutableDictionary<NSString *, NSString *> *) getAmounts {
    return self.amounts;
}

-(void) setVisionSubTotal:(NSDecimalNumber *)value {
    [self.amounts setValue:[value stringValue] forKey:@"SUBTOTAL_VISION__OPTICAL_AMT"];
    [self setTotalHealthCareAmount:value];
}

-(void) setClinicSubTotal:(NSDecimalNumber *)value {
    [self.amounts setValue:[value stringValue] forKey:@"SUBTOTAL_CLINIC_OR_OTHER_AMT"];
    [self setTotalHealthCareAmount:value];
}

-(void) setDentalSubTotal:(NSDecimalNumber *)value {
    [self.amounts setValue:[value stringValue] forKey:@"SUBTOTAL_DENTAL_AMT"];
    [self setTotalHealthCareAmount:value];
}

-(void) setPrescriptionSubTotal:(NSDecimalNumber *)value {
    [self.amounts setValue:[value stringValue] forKey:@"SUBTOTAL_PRESCRIPTION_AMT"];
    [self setTotalHealthCareAmount:value];
}

@end
