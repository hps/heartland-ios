#import "HpsPaxExtDataSubGroup.h"

@implementation HpsPaxExtDataSubGroup

- (id)init{
    self = [super init];
    if (!self) return nil;
    self.collection = [[NSMutableDictionary alloc] init];
    return self;
}

- (id)initWithBinaryReader: (HpsBinaryDataScanner*)br {
    self = [self init];
    
    NSString *values = [br readStringUntilDelimiter:HpsControlCodes_ETX];
    NSArray *items = [values componentsSeparatedByString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
 
    for (NSString* value in items) {
        NSArray *kvp = [value componentsSeparatedByString:@"="];
        if (kvp.count > 1) {
            [self.collection setObject:kvp[1] forKey:kvp[0]];
        }
    }
    return self;
}

- (NSString*) getElementString
{
    NSMutableString *sb = [[NSMutableString alloc] init];
 
    for (NSString *key in self.collection) {
        if (sb.length > 0){
            [sb appendString:[HpsTerminalEnums controlCodeString:HpsControlCodes_US]];
        }
        [sb appendString:[NSString stringWithFormat:@"%@=%@",key,[self.collection objectForKey:key]]];
    }
    return [sb copy];
}
 
@end
