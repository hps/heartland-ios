/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

@interface CertificateInfo : NSObject

/**
 *  CertificateInfo commonName value
 */
@property NSString* commonName;

/**
 *  CertificateInfo oid value
 */
@property NSString* oid;

/**
 *  CertificateInfo date value
 */
@property NSString* dateValue;

-(id)initWithData:(NSString*) certificateInfo;

-(id)initCustomerCertificateWithData:(NSString*) certificateInfo;
    
-(NSString*) toString;

@end
