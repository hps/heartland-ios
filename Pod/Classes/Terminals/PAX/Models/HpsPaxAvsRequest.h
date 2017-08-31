//  Copyright (c) 2016 Heartland Payment Systems. All rights reserved.

#import <Foundation/Foundation.h>
#import "HpsDeviceProtocols.h"

@interface HpsPaxAvsRequest : NSObject <IHPSRequestSubGroup>

@property (nonatomic,strong) NSString *zipCode;
@property (nonatomic,strong) NSString *address;
- (NSString*) getElementString;
@end
