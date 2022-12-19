#import <Foundation/Foundation.h>
#import "HpsPayrollConfig.h"
#import "HpsRestGateway.h"
#import "HpsPayrollEncoder.h"
#import "HpsBasePayrollResponse.h"
#import "HpsPayRollRequest.h"
#import "HpsPayrollRecord.h"
#import "HpsPayItem.h"
#import "HpsPayGroup.h"
#import "HpsWorkLocation.h"
#import "HpsEmployee.h"
#import "HpsEmployeeFinder.h"
#import "HpsClientInfo.h"
#import "HpsTerminationReason.h"
#import "HpsLaborField.h"
#import "HpsEnum.h"

@interface HpsPayrollService : HpsRestGateway

@property (nonatomic, strong) HpsPayrollEncoder *encoder;

-(id)initWithConfig:(HpsPayrollConfig *)payrollConfig;
-(void)getClientInfo:(NSInteger)federalEin withCompletion:(void(^)(NSArray *response, NSError* error))responseBlock;
-(HpsEmployeeFinder*)getEmployees:(NSString*)clientCode;
-(void)addEmployee:(HpsEmployee*)employee handler:(void(^)(HpsEmployee* employee))completionBlock;
-(void)updateEmployee:(HpsEmployee*)employee handler:(void(^)(HpsEmployee* employee))completionBlock;
-(void)terminateEmployee:(HpsEmployee*)employee date:(NSDate*)terminationDate reason:(HpsTerminationReason*)terminationReason and:(BOOL)deactivateAccounts handler:(void(^)(HpsEmployee* employee))completionBlock;
-(void)getTerminationReasons:(NSString *)clientCode handler:(void(^)(NSMutableArray* arr))completionBlock;
-(void)getWorkLocation:(NSString *)clientCode handler:(void(^)(NSMutableArray* arr))completionBlock;
-(void)getLaborFields:(NSString *)clientCode handler:(void(^)(NSMutableArray* arr))completionBlock;
-(void)getPayGroups:(NSString *)clientCode handler:(void(^)(NSMutableArray* arr))completionBlock;
-(void)getPayItems:(NSString *)clientCode handler:(void(^)(NSMutableArray* arr))completionBlock;
-(void)postPayrollDatas:(NSMutableArray*)payrollRecords handler:(void(^)(BOOL isResponse))completionBlock;
-(void)signIn;
-(void)signOut;
-(void)sendEncryptedRequest:(HpsPayRollRequest*)payrollRequest handler:(void(^)(NSString *response, NSError *error, HpsPayrollEncoder *encoder))responseBlock;


@end
