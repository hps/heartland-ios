//
//  HpsService.h
//  SecureSubmit
//
//  Created by Roberts, Jerry on 7/21/14.
//  Copyright (c) 2014 Heartland Payment Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HpsTransaction.h"
#import "HpsGatewayData.h"

@class HpsServicesConfig;


@interface HpsGatewayService : NSObject

- (id) initWithConfig:(HpsServicesConfig *) config;

- (void) doTransaction:(HpsTransaction *)transaction withResponseBlock:(void(^)(HpsGatewayData*, NSError*))responseBlock;
@end
