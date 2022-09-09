//
//  MBUPAErrorType.h
//  Pods
//
//  Created by Desimini, Wilson on 9/9/22.
//

typedef enum : NSUInteger {
    MBUPAErrorTypeNone = 0,
    MBUPAErrorTypeDeviceBusy,
    MBUPAErrorTypeDeviceTimeout,
    MBUPAErrorTypeConnectionForceClose,
    MBUPAErrorTypeConnectionUnexpectedClose,
    MBUPAErrorTypeCommunicationInvalidMessage,
    MBUPAErrorTypeUnknown,
} MBUPAErrorType;
