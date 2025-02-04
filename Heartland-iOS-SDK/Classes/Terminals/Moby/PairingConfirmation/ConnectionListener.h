//
//  ConnectionListener.h
//  Heartland-iOS-SDK
//
//  Created by Renato Santos on 09/08/2024.
//
#import <Foundation/Foundation.h>

#ifndef ConnectionListener_h
#define ConnectionListener_h


@protocol ConnectionListener <NSObject>

/**
 * Called to indicate that the pairing process has successfully completed.
 */

- (void)onDeviceConnected;
- (void)onDeviceConnectionFailed;
- (void)onDeviceConnectionCancelled;

@end


#endif /* ConnectionListener_h */
