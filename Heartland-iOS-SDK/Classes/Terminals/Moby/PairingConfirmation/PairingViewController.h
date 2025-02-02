/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2019. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <UIKit/UIKit.h>
#import <RUA.h>
//#import <ConnectionListener.h>

NS_ASSUME_NONNULL_BEGIN

@interface PairingViewController : UIViewController

@property RUADevice * selectedDevice;
//@property(nonatomic, weak)id <ConnectionListener> delegate;

@end

NS_ASSUME_NONNULL_END
