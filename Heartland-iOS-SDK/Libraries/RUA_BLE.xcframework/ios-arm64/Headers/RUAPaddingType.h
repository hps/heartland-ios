//
//  RUAPaddingType.h
//  ROAMreaderUnifiedAPI
//
//  Created by Occ Mobility on 28/11/2022.
//  Copyright © 2022 ROAM. All rights reserved.
//

#ifndef RUAPaddingType_h
#define RUAPaddingType_h

typedef NS_ENUM (NSInteger, RUAPaddingType) {
    RUAPaddingTypeNoPadding = 0,
    RUAPaddingTypeSha1 = 1,
    RUAPaddingTypeSha256 = 2,
    RUAPaddingTypeISOEIC7816 = 3,
    RUAPaddingTypeDefaultZeroPadding = 4,
    RUAPaddingTypePKCS5 = 5,
    RUAPaddingTypePKCS7 = 6
} ;

#endif /* RUAPaddingType_h */
