/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import "BaseKeyMap.h"

@interface DUKPTKey : BaseKeyMap

/**
 *  DUKPT KSN
 */
@property NSString* ksn;
/**
 *  DUKPT Encrypted_value
 */
@property NSString*encryptedValue;

-(id)initWithKeyName:(NSString *)keyName ksn:(NSString*)ksn encryptedValue:(NSString*)value;
-(NSString*) toString;

@end
