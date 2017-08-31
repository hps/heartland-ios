//  Copyright (c) 2016 Heartland Payment Systems. All rights reserved.

#import <Foundation/Foundation.h>
#import "HpsBinaryDataScanner.h"
#import "HpsTerminalEnums.h"
@interface HpsPaxCommercialResponse : NSObject
@property (nonatomic,strong) NSString *poNumber;
@property (nonatomic,strong) NSString *customerCode;
@property (nonatomic) BOOL taxExept;
@property (nonatomic,strong) NSString *taxExeptId;

- (id)initWithBinaryReader: (HpsBinaryDataScanner*)br;
@end
