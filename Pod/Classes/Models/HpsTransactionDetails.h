//  Copyright (c) 2016 Heartland Payment Systems. All rights reserved.

#import <Foundation/Foundation.h>

@interface HpsTransactionDetails : NSObject

@property (nonatomic) long clientTransactionId;
@property (nonatomic, strong) NSString* memo;
@property (nonatomic, strong) NSString* invoiceNumber;
@property (nonatomic, strong) NSString* customerId;

@end
