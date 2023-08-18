//
//  BBDeviceCAPK.h
//
//  Created by Alex Wong on 2017-08-18.
//  Copyright © 2021 BBPOS International Limited. All rights reserved. All software, both binary and source code published by BBPOS International Limited (hereafter BBPOS) is copyrighted by BBPOS and ownership of all right, title and interest in and to the software remains with BBPOS.
//  RESTRICTED DOCUMENT
//

#import <Foundation/Foundation.h>

@interface BBDeviceCAPK : NSObject{
    NSString *location;
    NSString *index;
    NSString *size;
    NSString *rid;
    NSString *modulus;
    NSString *exponent;
    NSString *checksum;
}

@property (atomic, retain) NSString *location;
@property (atomic, retain) NSString *index;
@property (atomic, retain) NSString *size;
@property (atomic, retain) NSString *rid;
@property (atomic, retain) NSString *modulus;
@property (atomic, retain) NSString *exponent;
@property (atomic, retain) NSString *checksum;

@end
