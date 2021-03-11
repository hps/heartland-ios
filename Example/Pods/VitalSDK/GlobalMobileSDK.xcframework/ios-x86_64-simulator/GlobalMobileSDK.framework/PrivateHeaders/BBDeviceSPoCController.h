//
//  BBDeviceSPoCController
//
//  Created by Alex Wong on 2018-03-30
//  Copyright (c) 2018 BBPOS Limited. All rights reserved.
//  RESTRICTED DOCUMENT
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BBDeviceSPoCController : NSObject{
}

+ (BBDeviceSPoCController *)sharedController;

#pragma mark - Public

- (NSString *)getApiVersion;
- (NSString *)getApiBuildNumber;

// -------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------

#pragma mark - PIN Pad Customization

- (void)showPinPadView_Debug:(NSString *)TLV;

+ (NSString *)getPropertyTagValue_Int:(int)value;
+ (NSString *)getPropertyTagValue_Float:(float)inValue floatDataFormat:(int)floatDataFormat;
+ (NSString *)getPropertyTagValue_Color:(int)rgbValue alpha:(float)alpha;
+ (NSString *)getPropertyTagValue_Image:(UIImage *)value;
+ (NSString *)getPropertyTagValue_String:(NSString *)value;
+ (NSString *)encodeTlv:(NSDictionary *)data;

@end
