//
//  HpsPaxDebitVoidBuilder.h
//  pos
//
//  Created by Desimini, Wilson on 3/4/20.
//  Copyright © 2020 MobileBytes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HpsPaxMessageIDs.h"
#import "HpsPaxDebitResponse.h"
#import "HpsPaxAvsRequest.h"
#import "HpsPaxAccountRequest.h"
#import "HpsPaxCashierSubGroup.h"
#import "HpsPaxCommercialRequest.h"
#import "HpsPaxAmountRequest.h"
#import "HpsPaxTraceRequest.h"
#import "HpsPaxEcomSubGroup.h"
#import "HpsPaxExtDataSubGroup.h"
#import "HpsPaxDevice.h"

NS_ASSUME_NONNULL_BEGIN

@interface HpsPaxDebitVoidBuilder : NSObject
{
    HpsPaxDevice *device;
}

@property (nonatomic, readwrite) int referenceNumber;
@property (nonatomic, readwrite) int transactionId;
@property (nonatomic, readwrite) int transactionNumber;

- (void)execute:(void(^)(HpsPaxDebitResponse*, NSError*))responseBlock;
- (id)initWithDevice: (HpsPaxDevice*)paxDevice;

@end

NS_ASSUME_NONNULL_END
