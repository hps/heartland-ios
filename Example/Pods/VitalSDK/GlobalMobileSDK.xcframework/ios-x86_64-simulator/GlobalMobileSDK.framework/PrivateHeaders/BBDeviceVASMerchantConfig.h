//
//  BBDeviceVASMerchantConfig
//
//  Created by Alex Wong on 2017-08-18.
//  Copyright © 2020 BBPOS Limited. All rights reserved.
//  RESTRICTED DOCUMENT
//

#import <Foundation/Foundation.h>

@interface BBDeviceVASMerchantConfig : NSObject{
    int protocolMode;
    NSString *merchantID;
    NSString *filter;
    NSString *url;
}

@property (nonatomic, assign) int protocolMode;
@property (nonatomic, retain) NSString *merchantID;
@property (nonatomic, retain) NSString *filter;
@property (nonatomic, retain) NSString *url;

@end
