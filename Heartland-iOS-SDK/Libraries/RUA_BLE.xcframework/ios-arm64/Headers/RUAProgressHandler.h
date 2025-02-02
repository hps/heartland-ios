/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */
#import "RUADeviceResponseHandler.h"

@protocol RUAProgressHandler <NSObject>

/**
 * Called when the roam reader indicates progress while processing the command.
 *
 * @param message the message
 * @param additionalMessage the addtional message
 * @see RUAProgressMessage
 */
-(void)onProgress:(RUAProgressMessage)message andAddtionalMessage:(NSString *)additionalMessage;

@end
