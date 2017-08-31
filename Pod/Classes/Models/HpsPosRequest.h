//
//  HpsPosRequest.h
//  Copyright (c) 2015 Heartland Payment Systems. All rights reserved.
//
//  Created by Shaunti Fondrisi on 12/14/15.
//
//

#import <Foundation/Foundation.h>
#import "HpsHeader.h"
#import "HpsTransaction.h"
 
@interface HpsPosRequest : NSObject
@property (nonatomic, strong) HpsHeader *header;
@property (nonatomic, strong) HpsTransaction *transaction;

- (NSString*) toXML;

@end
