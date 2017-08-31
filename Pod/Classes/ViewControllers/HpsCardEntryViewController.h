//
//  HPSCardEntryViewController.h
//  Heartland E-Cart
//
//  Created by Shaunti Fondrisi on 10/23/15.
//  Copyright © 2015 Heartland Payment Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HpsTokenData.h"

typedef void(^CallbackBlockType)(HpsTokenData*);

@interface HpsCardEntryViewController : UIViewController

@property(nonatomic, strong) NSString* publicKey;

- (void) setCallBackBlock:(void(^)(HpsTokenData*))block;

@end
