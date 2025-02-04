//
//  RUAPairingViewControllerDelegate.h
//  ROAMreaderUnifiedAPI
//
//  Created by Abhiram Dinesh on 10/7/20.
//  Copyright © 2020 ROAM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUADevice.h"
#import "RUADeviceManager.h"

#ifndef RUAPairingViewControllerDelegate_h
#define RUAPairingViewControllerDelegate_h

@protocol  RUAPairingViewControllerDelegate <NSObject>

- (void) connectedToDevice:(RUADevice *)device deviceManager:(id<RUADeviceManager>) deviceManager;

- (void) done;

@end

#endif /* RUAPairingViewControllerDelegate_h */
