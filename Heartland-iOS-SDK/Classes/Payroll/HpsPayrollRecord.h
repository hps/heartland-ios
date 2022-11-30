#import <Foundation/Foundation.h>
#import "HpsPayrollEncoder.h"
#import "HpsJsonDoc.h"

@interface HpsPayrollRecord : NSObject

@property (assign) NSInteger recordId;
@property (nonatomic, strong) NSString *clientCode;
@property (assign) NSInteger employeeId;
@property (nonatomic, strong) NSMutableArray *payItemLaborFields;
@property (nonatomic, strong) NSString *payItemTitle;
@property (nonatomic, strong) NSNumber *hours;
@property (nonatomic, strong) NSNumber *dollars;
@property (nonatomic, strong) NSNumber *payrate;

-(NSString *)toJson:(HpsPayrollEncoder*)encoder;

@end
