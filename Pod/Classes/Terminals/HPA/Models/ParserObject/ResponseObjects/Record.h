#import <Foundation/Foundation.h>
#import "NSObject+ObjectMap.h"
#import "Field.h"

@interface Record : NSObject

@property (atomic,retain) NSString *TableCategory;
@property (nonatomic,strong) Field *Field;
@property (atomic,retain) NSMutableDictionary *Fields;

@end
