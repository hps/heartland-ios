/*
* //////////////////////////////////////////////////////////////////////////////
* //
* // Copyright © Ingenico Retail Enterprise US Inc., All Rights Reserved.
* //
* //////////////////////////////////////////////////////////////////////////////
*/

#import <UIKit/UIKit.h>
#import "RUADeviceManager.h"
#import "RUAPairingViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface RUAPairingViewController : UIViewController

-(id) initWithDeviceStatusHandler:(id<RUADeviceStatusHandler> _Nonnull) statusHandler delegate:(id<RUAPairingViewControllerDelegate> _Nonnull) delegate;

- (void) setDeviceStatusHandler:(id <RUADeviceStatusHandler> _Nonnull) statusHandler;

- (void) setDeviceDelegate:(id <RUAPairingViewControllerDelegate> _Nonnull) delegate;

@end

NS_ASSUME_NONNULL_END
