
#import "HpsHpaDiagnosticResponse.h"
#import "HpsHpaParser.h"


#define SHARED_PARAMS [HpsHpaSharedParams getInstance]

@implementation HpsHpaDiagnosticResponse

-(id)initWithResponse:(NSData *)data
{
    self = [super init];
    
    self.rebootLogRecord = [NSMutableArray new];
    
    NSString *xmlString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray *arr = [xmlString componentsSeparatedByString:@"</SIP>"];
    
    for (NSString *response in arr) {
        
        id <HpaResposeInterface> responeN = [HpsHpaParser parseResponseWithXmlString:[NSString stringWithFormat:@"%@</SIP>",response]];
        
        [self mapResponse:responeN];
    }
    
    return self;
}

-(void)mapResponse:(id <HpaResposeInterface>)response {
    
    if(response.Result != nil)
    {
        self.deviceId = response.DeviceId;
        self.responseCode = response.Result;
        self.responseText = response.ResultText;
    NSString *Category = SHARED_PARAMS.tableCategory;
    if (Category != nil) {
    NSMutableDictionary *fieldValues = [SHARED_PARAMS.params objectForKey:Category];
    if ([Category isEqualToString:@"COMMAND"]) {
        
        self.commandRecord = fieldValues;
        
    }else if ([Category isEqualToString:@"SERIAL INTERFACE ERROR"]) {
        
        self.interfaceErrorRecord = fieldValues;
        
    }else if ([Category isEqualToString:@"REBOOT LOG"]) {
         NSMutableArray *rebootLog = [SHARED_PARAMS.paramsInArray objectForKey:Category];
         if (rebootLog.count != self.rebootLogRecord.count) {
            for(Field *field in rebootLog){
              
                NSString *tempStr = [field.Value stringByReplacingOccurrencesOfString:@"REBOOT@" withString:@""];
                NSDateFormatter* dateFormatter = [NSDateFormatter new];
                dateFormatter.dateFormat = @"MMddyyHHmmss";
                NSDate *rebootLogDate = [dateFormatter dateFromString:tempStr];
                dateFormatter.dateFormat = @"dd-MM-yy HH:mm:ss";
                NSLog(@"Date: %@",[dateFormatter stringFromDate:rebootLogDate]);
                [self.rebootLogRecord addObject:[dateFormatter stringFromDate:rebootLogDate]];
                }
            }
        }
        
    }
}
}
@end
