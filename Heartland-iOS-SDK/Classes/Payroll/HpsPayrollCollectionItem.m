#import "HpsPayrollCollectionItem.h"

@interface HpsPayrollCollectionItem()

@property (nonatomic, strong) NSString* idField;
@property (nonatomic, strong) NSString* descriptionField;

@end

@implementation HpsPayrollCollectionItem

-(id)init:(NSString*)idFieldName field:(NSString*)descriptionFieldName {
    
    if (self = [super init]) {
        self.idField = idFieldName;
        self.descriptionField = descriptionFieldName;
    }
    
    return self;
}

-(void)fromJSON:(HpsJsonDoc *)doc withArgument:(HpsPayrollEncoder *)encoder {
    self.idValue = [doc getValue:self.idField];
    self.descriptionString = [doc getValue:self.descriptionField];
}

@end

