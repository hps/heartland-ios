//  Copyright (c) 2016 Heartland Payment Systems. All rights reserved.

#import <Foundation/Foundation.h>
#import "HpsDeviceProtocols.h"

@interface HpsPaxAmountRequest : NSObject <IHPSRequestSubGroup> 

@property (nonatomic,strong) NSString *transactionAmount;
@property (nonatomic,strong) NSString *tipAmount;
@property (nonatomic,strong) NSString *cashBackAmount;
@property (nonatomic,strong) NSString *merchantFee;
@property (nonatomic,strong) NSString *taxAmount;
@property (nonatomic,strong) NSString *fuelAmount;

- (NSString*) getElementString;

@end
