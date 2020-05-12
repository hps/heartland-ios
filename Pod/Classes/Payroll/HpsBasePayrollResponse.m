#import "HpsBasePayrollResponse.h"

@implementation HpsBasePayrollResponse

-(id)initWithRawResponse:(NSString*)rawResponse {
    
    if (self = [super init]) {
        
        HpsJsonDoc* doc = [[[HpsJsonDoc alloc] init] parse:rawResponse withEncoder:nil];
        [self mapResponseValues:doc];

        if (_statusCode != 200) {
            
            @throw [NSException exceptionWithName:@"HpsPayrollException" reason:self.responseMessage userInfo:nil];
        }
    }
    
    return self;
}

-(void)mapResponseValues:(HpsJsonDoc*)doc {

    self.totalRecords = [NSString stringWithFormat:@"%@",[doc getValue:@"TotalRecords"]].integerValue;
    self.rawResults = [NSMutableArray arrayWithArray:[doc getEnumerator:@"Results"]];
    self.statusCode = [NSString stringWithFormat:@"%@",[doc getValue:@"StatusCode"]].integerValue;
    self.responseMessage = [NSString stringWithFormat:@"%@",[doc getValue:@"ResponseMessage"]];

	NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
	NSDateFormatter* dateFormatter = [NSDateFormatter new];
	dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZZZZ";
	dateFormatter.locale = enUSPOSIXLocale;
	dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSString* strDate =  [doc getValue:@"Timestamp"];
    self.timestamp = [dateFormatter dateFromString:strDate];

//	dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//	dateFormatter.timeZone = [NSTimeZone systemTimeZone];
//	NSString *strDate_Time = [dateFormatter stringFromDate:self.timestamp];

}

@end
