#import <Foundation/Foundation.h>
#import "HpsPayRollRequest.h"
#import "HpsBasePayrollResponse.h"
#import "HpsEmployee.h"

@class HpsPayrollService;

@interface HpsEmployeeFinder : NSObject

-(id)initWith:(HpsPayrollService *)service;
-(HpsEmployeeFinder*)withClientCode:(NSString*)value;
-(HpsEmployeeFinder*)withEmployeeId:(NSInteger)value;
-(HpsEmployeeFinder*)activeOnly:(BOOL)value;
-(HpsEmployeeFinder*)withEmployeeOffset:(NSInteger)value;
-(HpsEmployeeFinder*)withEmployeeCount:(NSInteger)value;
-(HpsEmployeeFinder*)withFromDate:(NSDate*)value;
-(HpsEmployeeFinder*)withToDate:(NSDate*)value;
-(HpsEmployeeFinder*)withPayType:(FilterPayTypeCode)value;
-(void)find:(void(^)(NSMutableArray* arr))completionBlock;

@end
