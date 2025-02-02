/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>
#import "DUKPTKey.h"
#import "ThreeDesKey.h"

@interface RUAKeyMappingInfo : NSObject

/**
 *  List of DUKPT keys
 */
@property NSMutableArray* mDukptKeyList;
/**
 *  List of 3DES keys
 */
@property NSMutableArray* mThreeDesKeyList;

-(id)initWithData:(NSData*)data;

- (NSString *) toString;

@end
