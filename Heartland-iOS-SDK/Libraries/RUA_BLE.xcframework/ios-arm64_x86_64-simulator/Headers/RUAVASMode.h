/*
//////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
//
//////////////////////////////////////////////////////////////////////////////
*/

#ifndef RUAVASMode_h
#define RUAVASMode_h

/** @enum RUAVASMode
 Enumeration of the commands supported by RUA
 */
typedef NS_ENUM (NSInteger, RUAVASMode) {

    RUAVASModeVASOnly = 0,
    RUAVASModeDualMode = 1,
    RUAVASModePayOnly = 2,
    RUAVASModeSignUp = 3,
    RUAVASModeSingle = 4
};

#endif /* RUAVASMode_h */
