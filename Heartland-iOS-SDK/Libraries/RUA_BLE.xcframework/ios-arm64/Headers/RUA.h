/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>
#import "RUADeviceManager.h"
#import "RUAReaderVersionInfo.h"
#import "RUADebugLogListener.h"

static NSString * _Nonnull RUA_Version = @"2.4.5.1";

typedef void (^LogCaptureHandler)(BOOL succeed);
typedef void (^OnRepackageUNSFileHandler)(BOOL repackageSucceed)__deprecated;

@interface RUA : NSObject

/**
 Enables RUA log messages
 @param enable boolean to enable logging
 */
+ (void)enableDebugLogMessages:(BOOL)enable;

/**
 * Sets if the ROAMreaderUnifiedAPI has to operate in production mode.<br>
 *
 * By default, the production mode is enabled.
 *
 * Note: For now, debug logging cannot be enabled only if ROAMreaderUnified API is operating in production mode
 *
 * @param enable boolean to indicate that this is production mode
 *
 */
+ (void)setProductionMode:(BOOL)enable;

/**
 * Sets if the ROAMreaderUnifiedAPI has to post response on UI thread.<br>
 *
 * By default, the response will be posted on UI thread.
 *
 * @param postResponseOnUIThread boolean to post response on UI thread
 *
 */
+ (void)setPostResponseOnUIThread:(BOOL)postResponseOnUIThread;

/**
 Returns true if ROAMreaderUnifiedAPI has to post response on UI thread
 */
+ (BOOL)postResponseOnUIThread;

/**
 Returns true if RUA log messages are enabled
 */
+ (BOOL)debugLogEnabled;

/**
 * Sets the DebugLogListener to receive RUA log messages.<br>
 *
 * By default, the message will be logged through NSLog.
 *
 * @param listener the listener recives RUA log messages
 *
 */
+ (void)setDebugLogListener:(id<RUADebugLogListener> _Nullable)listener;

/**
 Returns the list of roam device types that are supported by the RUA
 <p>
 Usage: <br>
 <code>
 NSArray *supportedDevices = [RUA getSupportedDevices];
 </code>
 </p>
 @return NSArray containing the enumerations of reader types that are supported.
 @see RUADeviceType
 */
+ (NSArray * _Nonnull)getSupportedDevices;

/**
 Returns an instance of the device manager for the connected device and this auto detection works with the readers that have audio jack interface.
 @param type RUADeviceType roam reader type enumeration
 @return RUADeviceManager device manager for the device type specified
 @see RUADeviceType
 */
+ (id <RUADeviceManager> _Nullable)getDeviceManager:(RUADeviceType)type;


/**
 Returns an instance of the device manager for the device type specified.
 <p>
 Usage: <br>
 <code>
 id<RUADeviceManager> mRP750xReader = [RUA getDeviceManager:RUADeviceTypeRP750x];
 </code>
 </p>
 @param type RUADeviceType roam reader type enumeration
 @return RUADeviceManager device manager for the device type specified
 @see RUADeviceType
 */

+ (id <RUADeviceManager> _Nonnull)getAutoDetectDeviceManager:(NSArray* _Nonnull)type;

/**
 Returns the version of ROAMReaderUnifiedAPI (RUA)
 */
+ (NSString * _Nonnull) versionString __deprecated_msg("use RUA_Version instead");

/**
 * Returns a list of file version descriptions for each file
 * contained within the specified UNS file.
 * @param filePath path of the uns file
 * @see RUAFileVersionInfo
 *
 */

+ (NSArray* _Nullable)getUnsFileVersionInfo:(NSString* _Nonnull)filePath;

/**
 * Checks if the uns file is valid.
 * @param filePath path of the uns file
 * @return <code>true</code> if valid, <code>false</code> otherwise
 */
+ (BOOL)isValidUnsFile:(NSString* _Nullable)filePath;

/**
 * Repackage the speicified UNS file with reader version info
 * @param fromFilePath original UNS file path (eg. /var/mobile/Containers/Data/Application/447B9EDB-0B3E-49F2-98A5-6B5674401C61/Documents/original.uns)
 * @param toFilePath file save path for the repackage UNS file (eg. /var/mobile/Containers/Data/Application/447B9EDB-0B3E-49F2-98A5-6B5674401C61/Documents/newfile.uns)
 * @param readerVersionInfo reader version information
 * @see RUAReaderVersionInfo
 * @deprecated
 */
+ (void)repackageUNSFile:(NSString * _Nullable)fromFilePath toFilePath:(NSString * _Nullable)toFilePath andReaderVersion:(RUAReaderVersionInfo * _Nullable)readerVersionInfo response:(OnRepackageUNSFileHandler _Nonnull)handler __deprecated;

+ (void)repackageUNSFile:(NSString * _Nullable)fromFilePath toFilePath:(NSString * _Nullable)toFilePath andReaderVersion:(RUAReaderVersionInfo * _Nullable)readerVersionInfo withResponse:(OnResponse _Nonnull)response;

/**
 Start capturing RUA SDK and reader's logs. RUA will create and also write to the SDK log file under the path given.
 Note:
 1. This API can only be used when RUA is not in production mode. It will not have any effect and the LogCaptureHandler will return false if called in production mode.
 2. Reader should be connected at the time of calling this API in order to start collecting its logs, if not connected there will not be any reader log.
 @param path path where the log files will be saved to
 @param response response handler
 */
+ (void)startLogCapture:(NSString * _Nullable)path withResponse:(LogCaptureHandler _Nonnull)response;

/**
 Stop capturing RUA SDK and reader's logs. RUA will call retrieveLog API and create/write to the reader log file under the path provided in the startLogCapture API call.
 @param response response handler
 */
+ (void)stopLogCapture:(LogCaptureHandler _Nonnull)response;

@end
