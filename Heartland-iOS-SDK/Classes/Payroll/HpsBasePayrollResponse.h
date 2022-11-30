#import <Foundation/Foundation.h>
#import "HpsJsonDoc.h"

@interface HpsBasePayrollResponse : NSObject

@property  NSInteger totalRecords;
@property (nonatomic,strong) NSMutableArray* rawResults;
@property (nonatomic,strong) NSDate* timestamp;
@property  NSInteger statusCode;
@property (nonatomic,strong) NSString* responseMessage;

-(id)initWithRawResponse:(NSString*)rawResponse;

@end
