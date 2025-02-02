//
//  PairingBluetoothMode.h
//  ROAMreaderUnifiedAPI
//
//  Created by Occ Mobility on 20/06/2022.
//  Copyright © 2022 ROAM. All rights reserved.
//

#ifndef RUAPairingBluetoothMode_h
#define RUAPairingBluetoothMode_h

typedef NS_ENUM (NSInteger, RUAPairingBluetoothMode) {
    EmptyPairingList = 1,
    StartPairing = 2,
    EmptyListAndStartPairing = 3,
    EmptyPairingListAndReboot = 5,
    PasswordBTMenu = 6,
    PasswordMaintenanceMenu = 7
} ;

#endif /* RUAPairingBluetoothMode_h */
