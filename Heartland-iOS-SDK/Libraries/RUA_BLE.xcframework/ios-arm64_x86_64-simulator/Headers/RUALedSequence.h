/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2019. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>
#import "RUAByteUtils.h"

@interface RUALedSequence : NSObject

@property (nonatomic, readonly) BOOL redOn;
@property (nonatomic, readonly) BOOL yellowOn;
@property (nonatomic, readonly) BOOL orangeOn;
@property (nonatomic, readonly) BOOL blueOn;

-(instancetype) initWithRedOn:(BOOL) redOn yellowOn:(BOOL) yellowOn orangeOn:(BOOL) orangeOn blueOn:(BOOL) blueOn;
+ (NSArray *) getLedSequences:(NSData *) receivedData;

@end


