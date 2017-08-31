//  Copyright (c) 2016 Heartland Payment Systems. All rights reserved.

#import <Foundation/Foundation.h>
#import "HpsBinaryDataScanner.h"
#import "HpsTerminalEnums.h"

@interface HpsPaxTraceResponse : NSObject

@property (nonatomic,strong) NSString *referenceNumber;
@property (nonatomic,strong) NSString *transactionNunmber;
@property (nonatomic,strong) NSString *timeStamp;
 
- (id)initWithBinaryReader: (HpsBinaryDataScanner*)br;
@end
