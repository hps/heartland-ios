//
//  MBUPAErrorType.h
//  Pods
//
//  Created by Desimini, Wilson on 9/9/22.
//

typedef NS_ENUM(NSUInteger, MBUPAErrorType) {
    MBUPAErrorTypeNone = 0,
    MBUPAErrorTypeDeviceBusy,
    MBUPAErrorTypeDeviceTimeout,
    MBUPAErrorTypeConnectionForceClose,
    MBUPAErrorTypeConnectionUnexpectedClose,
    MBUPAErrorTypeCommunicationInvalidMessage,
    MBUPAErrorTypeUnknown,
};
