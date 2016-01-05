//
//  HpsCardData.h
//  Copyright (c) 2015 Heartland Payment Systems. All rights reserved.
//
//  Created by Shaunti Fondrisi on 12/8/15.
//
//

#import <Foundation/Foundation.h>


@interface HpsCardData : NSObject

@property (nonatomic, strong) NSString *expMonth;
@property (nonatomic) BOOL cardPresent;
@property (nonatomic, strong) NSString *expYear;
@property (nonatomic) BOOL readerPresent;
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic) BOOL requestToken;
@property (nonatomic) NSString* cvv2;
- (NSString*) toXML;
@end
