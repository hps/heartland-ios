#import <Foundation/Foundation.h>
#import "HpsPayrollEntity.h"

@interface HpsPayrollCollectionItem : HpsPayrollEntity

@property (nonatomic, strong) NSString* idValue;
@property (nonatomic, strong) NSString* descriptionString;

-(id)init:(NSString*)idFieldName field:(NSString*)descriptionFieldName;
-(void)fromJSON:(HpsJsonDoc *)doc withArgument:(HpsPayrollEncoder *)encoder;

@end
