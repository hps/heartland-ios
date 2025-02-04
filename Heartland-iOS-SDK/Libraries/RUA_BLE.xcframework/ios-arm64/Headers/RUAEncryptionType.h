//
//  RUAEncryptionType.h
//  ROAMreaderUnifiedAPI
//
//  Created by Occ Mobility on 28/11/2022.
//  Copyright © 2022 ROAM. All rights reserved.
//

#ifndef RUAEncryptionType_h
#define RUAEncryptionType_h

typedef NS_ENUM (NSInteger, RUAEncryptionType) {
    RUAEncryptionType3Des = 0,
    RUAEncryptionTypeAes = 1,
    RUAEncryptionTypeRsaOeap = 2,
    RUAEncryptionTypeRsaWallmart = 3
} ;

#endif /* RUAEncryptionType_h */
