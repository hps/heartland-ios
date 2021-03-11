#import <Foundation/Foundation.h>
#import "HpsPayrollEntity.h"
#import "HpsEnum.h"
#import "HpsPayRollRequest.h"

@interface HpsEmployee : HpsPayrollEntity

@property (nonatomic, strong) NSString* clientCode;
@property (assign) NSInteger employeeId;
@property EmploymentStatus employmentStatus;
@property (nonatomic, strong) NSDate* hireDate;
@property (nonatomic, strong) NSDate* terminationDate;
@property (nonatomic, strong) NSString* terminationReasonId;
@property (nonatomic, strong) NSString* employeeNumber;
@property EmploymentCategory employmentCategory;
@property (assign) NSInteger timeClockId;
@property (nonatomic, strong) NSString* firstName;
@property (nonatomic, strong) NSString* lastName;
@property (nonatomic, strong) NSString* middleName;
@property (nonatomic, strong) NSString* ssn;
@property (nonatomic, strong) NSString* address1;
@property (nonatomic, strong) NSString* address2;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* stateCode;
@property (nonatomic, strong) NSString* zipCode;
@property MaritalStatus maritalStatus;
@property (nonatomic, strong) NSDate* birthDay;
@property Gender gender;
@property (assign) NSInteger payGroupId;
@property PayTypeCode payTypeCode;
@property (assign) CGFloat hourlyRate;
@property (assign) CGFloat perPaySalary;
@property (assign) NSInteger workLocationId;
@property (assign) BOOL deactivateAccounts;

-(HpsPayRollRequest*)addEmployeeRequest:(HpsPayrollEncoder*)encoder;
-(HpsPayRollRequest*)updateEmployeeRequest:(HpsPayrollEncoder*)encoder;
-(HpsPayRollRequest*)terminateEmployeeRequest:(HpsPayrollEncoder*)encoder;

@end
