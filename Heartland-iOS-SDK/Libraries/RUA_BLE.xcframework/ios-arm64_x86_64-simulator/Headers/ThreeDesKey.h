/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import "BaseKeyMap.h"

@interface ThreeDesKey : BaseKeyMap
/**
 *  3DES KCV
 */
@property NSString* kcv;


-(id)initWithKeyName:(NSString *)keyName kcv:(NSString*)kcv;
-(NSString*) toString;

@end
