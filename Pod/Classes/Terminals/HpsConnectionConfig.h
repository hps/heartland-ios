//  Copyright (c) 2016 Heartland Payment Systems. All rights reserved.

#import <Foundation/Foundation.h>


@interface HpsConnectionConfig : NSObject

@property (nonatomic) NSInteger connectionMode;

@property (nonatomic, strong) NSString *ipAddress;
@property (nonatomic, strong) NSString *port;

@property (nonatomic) NSInteger baudeRate;
@property (nonatomic) NSInteger parity;
@property (nonatomic) NSInteger stopBits;
@property (nonatomic) NSInteger dataBits;


@property (nonatomic) NSInteger *timeout;


- (BOOL) validate;



@end
