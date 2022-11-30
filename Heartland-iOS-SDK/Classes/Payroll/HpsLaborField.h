#import <Foundation/Foundation.h>
#import "HpsPayrollCollectionItem.h"
#import "HpsLaborFieldLookup.h"

@interface HpsLaborField : HpsPayrollCollectionItem

@property (nonatomic, strong) NSMutableArray* lookUp;

@end
