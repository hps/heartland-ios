//
//  BBDeviceVASMerchantConfig
//
//  Created by Alex Wong on 2017-08-18.
//  Copyright © 2021 BBPOS International Limited. All rights reserved. All software, both binary and source code published by BBPOS International Limited (hereafter BBPOS) is copyrighted by BBPOS and ownership of all right, title and interest in and to the software remains with BBPOS.
//  RESTRICTED DOCUMENT
//

#import <Foundation/Foundation.h>

@interface BBDeviceVASMerchantConfig : NSObject{
    int protocolMode;
    NSString *merchantID;
    NSString *filter;
    NSString *url;
}

@property (atomic, assign) int protocolMode;
@property (atomic, retain) NSString *merchantID;
@property (atomic, retain) NSString *filter;
@property (atomic, retain) NSString *url;

@end
