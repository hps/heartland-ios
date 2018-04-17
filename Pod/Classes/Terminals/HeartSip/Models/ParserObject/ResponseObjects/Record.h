	//  Copyright (c) 2017 Heartland Payment Systems. All rights reserved.

#import <Foundation/Foundation.h>
#import "NSObject+ObjectMap.h"
#import "Field.h"

@interface Record : NSObject

@property (atomic,retain) NSString *TableCategory;
@property (atomic,strong) Field *Field;
@property (atomic,retain) NSMutableDictionary *Fields;

@end
