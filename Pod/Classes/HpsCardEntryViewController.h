//
//  HPSCardEntryViewController.h
//  Heartland E-Cart
//
//  Created by Shaunti Fondrisi on 10/23/15.
//  Copyright © 2015 Heartland Payment Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HpsTokenResponse.h"

typedef void(^CallbackBlockType)(HpsTokenResponse*);

@interface HpsCardEntryViewController : UIViewController

@property(nonatomic, strong) NSString* publicKey;

- (void) setCallBackBlock:(void(^)(HpsTokenResponse*))block;

@end
