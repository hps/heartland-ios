#import "HpsLaborField.h"

@implementation HpsLaborField

-(id)init {
    
    if (self =[super init]) { }
    
    return [self init:@"LaborFieldId" field:@"LaborFieldValue"];
}

-(void)fromJSON:(HpsJsonDoc *)doc withArgument:(HpsPayrollEncoder *)encoder {
    
    [super fromJSON:doc withArgument:encoder];
    
    if (self.descriptionString == nil) {
        self.descriptionString = [doc getValue:@"LaborFieldTitle"];
    }
    
    if ([doc.dict objectForKey:@"laborfieldLookups"]) {
        
        self.lookUp = [NSMutableArray new];
        
        for (HpsJsonDoc *jsonDoc in [doc getEnumerator:@"laborfieldLookups"]) {
            HpsLaborFieldLookup* laborFieldLookUp = [[HpsLaborFieldLookup alloc] init];
            laborFieldLookUp.descriptionString = [jsonDoc getValue:@"laborFieldDescription"];
            laborFieldLookUp.value = [jsonDoc getValue:@"laborFieldValue"];
            [self.lookUp addObject:laborFieldLookUp];
        }
    }
}

@end
