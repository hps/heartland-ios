//  Copyright (c) 2016 Heartland Payment Systems. All rights reserved.

#import <Foundation/Foundation.h>
#import "HpsDeviceProtocols.h"

@interface HpsPaxTraceRequest : NSObject <IHPSRequestSubGroup>
@property (nonatomic,strong) NSString *referenceNumber;
@property (nonatomic,strong) NSString *invoiceNumber;
@property (nonatomic,strong) NSString *authCode;
@property (nonatomic,strong) NSString *transactionNumber;
@property (nonatomic,strong) NSString *timeStamp;

- (NSString*) getElementString;
@end
