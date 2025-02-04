/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>
#import "RUAProgressHandler.h"
#import "RUATransactionManager.h"
#import "RUAConfigurationManager.h"
#import "RUADeviceStatusHandler.h"
#import "RUAReleaseHandler.h"
#import "RUADeviceSearchListener.h"
#import "RUAAudioJackPairingListener.h"
#import "RUATurnOnDeviceCallback.h"

#ifndef RUADeviceManager_h
#define RUADeviceManager_h

typedef  enum {
	RUADeviceTypeG4x __attribute__((deprecated)),
	RUADeviceTypeRP350x __attribute__((deprecated)),
    RUADeviceTypeMOBY3000,
    RUADeviceTypeRP450c,
	RUADeviceTypeRP750x,
    RUADeviceTypeRP45BT,
    RUADeviceTypeMOBY8500,
    RUADeviceTypeMOBY6500,
    RUADeviceTypeMOBY5500,
	RUADeviceTypeUnknown
}RUADeviceType;

/**
 The Device Manager interface manages all the interactions with the roam device.
 */

@protocol RUADeviceManager <NSObject>

/**
 Returns transaction manager of the roam device.
 @return RUATransactionManager reader configuration manager
 @see RUATransactionManager
 */

- (id <RUATransactionManager> _Nonnull)getTransactionManager;

/**
 Returns configuration manager of the roam device.
 @return RUAConfigurationManager reader configuration manager
 @see RUAConfigurationManager
 */
- (id <RUAConfigurationManager> _Nonnull)getConfigurationManager;

/**
 Returns the Device type
 @return RUADeviceType enumeration of the roam device type
 @see RUADeviceType
 */

- (RUADeviceType)getType;

/**
 Initializes the roam reader (through audio jack or bluetooth) and registers the status handler for device status updates.
 <p>
 Usage:
 <code>
 <br>
 id<Reader> mRP750xReader;
 id<RUADeviceStatusHandler> mRUADeviceStatusHandler;
 [mRP750xReader initialize:mRUADeviceStatusHandler];
 </code>
 </p>
 @param statusHandler the roam reader  status handler
 @see RUADeviceStatusHandler
 @return true if successful
 */
- (BOOL)initializeDevice:(id <RUADeviceStatusHandler> _Nonnull)statusHandler;

/**
 Initializes the roam reader (through audio jack or bluetooth) with defined timeout and registers the status handler for device status updates.
 <p>
 Usage:
 <code>
 <br>
 id<Reader> mRP750xReader;
 id<RUADeviceStatusHandler> mRUADeviceStatusHandler;
 [mRP750xReader initialize:mRUADeviceStatusHandler andTimeout:30*1000];
 </code>
 </p>
 @param statusHandler the roam reader  status handler
 @param timeout defined timeout in millisecond(Default 30 seconds)
 @see RUADeviceStatusHandler
 @return true if successful
 */
- (BOOL)initializeDevice:(id <RUADeviceStatusHandler> _Nonnull)statusHandler andTimeout:(int)timeout;

/**
 * Registers the handler to receive progress updates
 * @param handler the handler that receives progress updates
 * @see RUAProgressHandler
 */
- (void)registerProgressHandler:(id<RUAProgressHandler> _Nonnull)handler;

/**
 * Unregisters the handler to stop receiving progress updates
 * @param handler the handler that receives progress updates
 * @see RUAProgressHandler
 */
- (void)unregisterProgressHandler:(id<RUAProgressHandler> _Nonnull)handler;

/**
 Checks if the payment device is ready.
 *
 @return true if payment device is active
 */
- (BOOL)isReady;

/**
 Releases the roam reader and triggers status handler (passed to the initialize method) onDisconnected call back method if successful.
 *
 @return true if successful
 */
- (BOOL)releaseDevice;


/**
 Releases the roam reader and triggers status handler (passed to the initialize method) onDisconnected call back method if successful.
 @param releaseHandler release handler
 */
- (void)releaseDevice:(id <RUAReleaseHandler> _Nonnull)releaseHandler;

/**
 Cancels any pending connection attempt to reader by sending a stop command.
 *
 @return true if successful, false if initializeDevice is not called or stopInitialization fails
 */
-(BOOL)stopInitialization;

/**
 Discovers the available devices for duration
 *
 @param searchListener the callback handler
 @param duration duration of the bluetooth discovery in milliseconds
 @see RUADeviceSearchListener
 */
- (void)searchDevicesForDuration:(long)duration andListener:(id <RUADeviceSearchListener> _Nonnull)searchListener;

/**
 Discovers the available devices
 *
 @param searchListener the callback handler
 @see RUADeviceSearchListener
 */
- (void)searchDevices:(id <RUADeviceSearchListener> _Nonnull)searchListener;

/**
 Discovers the available devices with lowRSSI and highRSSI<br>
 <br>
 RSSI stands for Received Signal Strength Indicator.<br>
 It is the strength of the beacon's signal as seen on the receiving device, e.g. a smartphone.<br>
 The signal strength depends on distance and Broadcasting Power value.<br>
 At maximum Broadcasting Power (+4 dBm) the RSSI ranges from -26 (a few inches) to -100 (40-50 m distance).<br>
 @param lowRSSI lowest RSSI
 @param highRSSI highest RSSI
 @param searchListener the callback handler
 @see RUADeviceSearchListener
 */
- (void)searchDevicesWithLowRSSI:(NSInteger)lowRSSI andHighRSSI:(NSInteger)highRSSI andListener:(id<RUADeviceSearchListener> _Nonnull)searchListener;

/**
 Discovers the available devices and only returns devices matching the list of communication interfaces passed<br>
 <br>
 RSSI stands for Received Signal Strength Indicator.<br>
 It is the strength of the beacon's signal as seen on the receiving device, e.g. a smartphone.<br>
 The signal strength depends on distance and Broadcasting Power value.<br>
 At maximum Broadcasting Power (+4 dBm) the RSSI ranges from -26 (a few inches) to -100 (40-50 m distance).<br>
 @param lowRSSI lowest RSSI. Applicable only if commInterfaces contain {@link CommunicationType#Bluetooth}
 @param highRSSI highest RSSI. Applicable only if commInterfaces contain {@link CommunicationType#Bluetooth}
 @param duration duration of the bluetooth discovery in milliseconds
 @param commInterfaces communication interfaces to include in the search results.
        Important: USB is only supported for MFI and will be ignored if its part of the list for BLE.
 @param searchListener the callback handler
 @see RUADeviceSearchListener
 */
- (void)searchDevicesWithLowRSSI:(NSInteger)lowRSSI andHighRSSI:(NSInteger)highRSSI andDuration:(long)duration andCommunicationInterfaces:(NSArray * _Nonnull)commInterfaces andListener:(id<RUADeviceSearchListener>_Nonnull)searchListener;

/**
 Stops the ongoing discovery process
 */
- (void)cancelSearch;

/**
 This is an Asynchronous method that returns the battery level of a device. <br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameter, RUAParameterBatteryLevel<br>
 @param response OnResponse block
 */
- (void)getBatteryStatus:(OnResponse _Nonnull)response;

/**
 This is an Asynchronous method that returns the battery level and charging status of a device. <br>
 <br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, 
 RUAParameterBatteryLevel,
 RUAParameterIsDeviceCharging<br>
 @param response OnResponse block
 */
- (void)getBatteryLevelWithChargingStatus:(OnResponse _Nonnull)response;

/**
 Asynchronous method that sets the card reader in firmware update mode

 @param response OnResponse block
*/
- (void) enableFirmwareUpdateMode:(OnResponse _Nonnull)response;

/**
 Triggers the firmware update with the file path provided and returns the response on the handler passed
 @param firmareFilePath Firmware file path string
 @param progress OnProgress block
 @param response OnResponse block
*/
- (void) updateFirmware:(NSString * _Nonnull) firmareFilePath progress:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 Triggers the firmware update with the file path provided and returns the response on the handler passed
 @param firmareFilePath Firmware file path string
 @param retryCount Number of times that firmware update will be attempted in case of failure
 @param progress OnProgress block
 @param response OnResponse block
*/
- (void) updateFirmware:(NSString * _Nonnull) firmareFilePath retryCount: (NSUInteger) retryCount progress:(OnProgress _Nonnull)progress response:(OnResponse _Nonnull)response;

/**
 Synchronous method that will cancel the firmware update process and force the reader to exit the firmware update mode
 */
- (void) cancelFirmwareUpdate;


/**
 This is an Asynchronous method that returns the statistics of a device, like the count of total number of swipes, bad swipes etc.,
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.
 The map passed to the onResponse callback contains the following parameters as keys,
	RUAParameterSystemCountPowerON,
	RUAParameterSystemCountKeyHit,
	RUAParameterSystemCountTotalSwipes,
	RUAParameterSystemCountAudioJackInsertions,
	RUAParameterSystemCountUSBEvent,
	RUAParameterSystemCountBadSwipes,
	RUAParameterSystemCountFallbackSwipes,
	RUAParameterSystemCountChipInsertions,
	RUAParameterSystemCountPowerOnFailForChipCards,
	RUAParameterSystemCountAPDUFailForChipCards,
	RUAParameterSystemCountRFWupa,
	RUAParameterSystemCountClessActivateFail,
	RUAParameterSystemCountClessAPDUFail,
	RUAParameterSystemCountCharges,
	RUAParameterSystemCountBluetoothConnectionsLost,
	RUAParameterSystemCountOutOfBattery,
	RUAParameterSystemCountCompleteCharge,
	RUAParameterSystemCountCommands
 @param response OnResponse block
 */
- (void) getDeviceStatistics:(OnResponse _Nonnull)response;


/**
 * Asynchronous method that will start the process of pairing with
 * a Bluetooth card reader via Audiojack or USB.
 * Supports RP450c(Audiojack) and Moby8500(USB).
 * <br>
 * @param pairListener, see {@link RUAPairingListener}
 */
- (void) requestPairing:(id <RUAPairingListener> _Nonnull) pairListener;

/**
 * Asynchronous method that will complete the process of pairing with
 * a Bluetooth card reader that doesn't have a keypad or display.
 * <br>
 * @deprecated
 * This call is not required for passkey confirmation
 */
- (void) confirmPairing:(BOOL)isMatching __deprecated;

/**
 * Returns the active communication type for those devices that can have multiple interfaces
 * connected at a point of time. E.g RP450c that is plugged in via audio jack and can have active
 * bluetooth connection.
 * @return {@see RUACommunicationInterface}
 */

-(RUACommunicationInterface) getActiveCommunicationType;

/**
 * Asynchronous method that will remotely turn on the device connected via audio jack.
 * Ensure that an audio jack device is plugged in before invoking this method.
 *
 * @param callback Callback
 */
- (void) turnOnDeviceViaAudioJack:(id<RUATurnOnDeviceCallback> _Nonnull)callback;

/**
Initializes the card reader and registers the status handler for device status updates.
Supports pairing LED pairing for Moby5500
@param statusHandler device status handler
@see RUADeviceStatusHandler
@param pairListener LED Pairing listener
@seeRUAPairingListener
@return true if successful
*/
- (BOOL)initializeDevice:(id <RUADeviceStatusHandler> _Nonnull)statusHandler pairingListener:(id <RUAPairingListener> _Nonnull) pairListener;

/**
* Cancel the BT pairing process via AJ for RP450 and USB for Moby8500
* Triggers pairingFailed on the original {@see RUAPairingListener}
*/
-(void) cancelPairing;
@end

#endif
