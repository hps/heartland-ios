//
//  HpsTransaction.h
//  Copyright (c) 2015 Heartland Payment Systems. All rights reserved.
//
//  Created by Shaunti Fondrisi on 12/8/15.
//
//

#import <Foundation/Foundation.h>

@class HpsCardData;
@class HpsCardHolderData;
@class HpsAdditionalTxnFields;

@interface HpsTransaction : NSObject

@property (nonatomic, strong) HpsCardData *cardData;
@property (nonatomic, strong) HpsCardHolderData *cardHolderData;
@property (nonatomic) double chargeAmount;
@property (nonatomic) BOOL allowDuplicate;
@property (nonatomic, strong) HpsAdditionalTxnFields *additionalTxnFields;
@property (nonatomic) BOOL allowPartialAuth;

- (NSString*) toXML;

@end
