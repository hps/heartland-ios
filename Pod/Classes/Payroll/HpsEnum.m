#import "HpsEnum.h"

@implementation HpsEnum

NSString * const EmploymentStatus_toString[] = {
    
    [ Active] = @"A",
    [ Inactive ] = @"I",
    [ Terminated ] = @"T",
};

NSString * const EmploymentCategory_toString[] = {
    
    [ FullTime] = @"FT",
    [ PartTime ] = @"PT"
};

NSString * const MaritalStatus_toString[] = {
    
    [ Married] = @"M",
    [ Single ] = @"S"
};

NSString * const Gender_toString[] = {
    
    [ Female] = @"F",
    [ Male ] = @"M"
};

NSString * const FilterPayTypeCode_toString[] = {
    
    [ Hourly] = @"H",
    [ T1099 ] = @"1099"
};

NSString * const PayTypeCode_toString[] = {
    
    [ PayType_Hourly] = @"H",
    [ Salary ] = @"S",
    [ PayType_T1099] = @"T99",
    [ T1099_Hourly ] = @"T99H",
    [ Commision] = @"C",
    [ AutoHourly ] = @"Ah",
    [ ManualSalary ] = @"Ms"
};

@end
