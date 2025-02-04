/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#ifndef RUACardInsertionStatus_h
#define RUACardInsertionStatus_h

typedef NS_ENUM(NSInteger, RUACardInsertionStatus) {
    
    RUACardInsertionStatusCardFullyRemoved = 0,
    
    RUACardInsertionStatusCardFullyInserted = 1,
    
    RUACardInsertionStatusUnknown = 2,
    
    RUACardInsertionStatusICCCardFullyRemoved = 3,
    
    RUACardInsertionStatusICCCardFullyInserted = 4,
    
    RUACardInsertionStatusRFCardFullyRemoved = 5,
    
    RUACardInsertionStatusRFCardFullyInserted = 6,
    
};

#endif /* RUACardInsertionStatus_h */
