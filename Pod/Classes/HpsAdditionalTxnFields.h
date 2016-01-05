//
//  HpsAdditionalTxnFields.h
//  Copyright (c) 2015 Heartland Payment Systems. All rights reserved.
//
//  Created by Shaunti Fondrisi on 12/8/15.
//
//

#import <Foundation/Foundation.h>

@interface HpsAdditionalTxnFields : NSObject

@property (nonatomic, strong) NSString *invoiceNumber;
@property (nonatomic, strong) NSString *customerID;
@property (nonatomic, strong) NSString *desc;
- (NSString*) toXML;
@end
