/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */
@protocol RUADebugLogListener <NSObject>

@optional
/**
 @deprecated
 Use "- (void)d:(NSString *)tag :(NSString *)message" instead
 */
- (void)debugLogMessage:(NSString *)message __deprecated;

/**
 Invoked when there is message with debug log level
 @param tag identifier
 @param message debug message
 */
- (void)d:(NSString *)tag :(NSString *)message;

/**
 Invoked when there is message with info log level
 @param tag identifier
 @param message debug message with information
 */
- (void)i:(NSString *)tag :(NSString *)message;

/**
 Invoked when there is message with error log level
 @param tag identifier
 @param message debug message with error
 */
- (void)e:(NSString *)tag :(NSString *)message;

@end
