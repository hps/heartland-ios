//
//  RUACardInsertionStatusType.h
//  ROAMreaderUnifiedAPI
//
//  Created by Occ Mobility on 21/06/2022.
//  Copyright © 2022 ROAM. All rights reserved.
//

#ifndef RUACardInsertionStatusType_h
#define RUACardInsertionStatusType_h

typedef NS_ENUM (NSInteger, RUACardInsertionStatusType) {
    ICC = 0,
    SAM = 1,
    RF = 2,
    MIFARE = 5,
    ICC_OR_RF = 16
} ;

#endif /* RUACardInsertionStatusType_h */
