/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

@interface RUADevice : NSObject <NSSecureCoding>

typedef enum {
	RUACommunicationInterfaceBluetooth = 0,
	RUACommunicationInterfaceAudioJack = 1,
	RUACommunicationInterfaceUnknown = 2,
    RUACommunicationInterfaceUSB = 3
} RUACommunicationInterface;

/**
 * Name of the RUADevice
 * */
@property NSString *name; // Name

/**
 * Identifier of the RUADevice
 * */
@property NSString *identifier; // identifier

/**
 * Enumeration of the communication interface available for the RUADevice
 * */
@property RUACommunicationInterface communicationInterface;

/**
 * RSSI value of the RUADevice(Default value is 0)
 * */
@property NSInteger RSSIvalue;

- (id)            initWithName:(NSString *)name
                withIdentifier:(NSString *)identifier
    withCommunicationInterface:(RUACommunicationInterface)interface;

- (id)            initWithName:(NSString *)name
                withIdentifier:(NSString *)identifier
    withCommunicationInterface:(RUACommunicationInterface)interface
                 withRSSIvalue:(NSInteger)rssivalue;

@end
