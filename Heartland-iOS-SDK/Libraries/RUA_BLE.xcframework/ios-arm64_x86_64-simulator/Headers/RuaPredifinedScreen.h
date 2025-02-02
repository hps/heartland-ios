//
//  RuaPredifinedScreen.h
//  ROAMreaderUnifiedAPI
//
//  Created by Occ Mobility on 17/06/2022.
//  Copyright © 2022 ROAM. All rights reserved.
//

#ifndef RuaPredifinedScreen_h
#define RuaPredifinedScreen_h

typedef NS_ENUM (NSInteger, RUADisplayPredifenedScreen) {
    //    0    C0FD
    DSP_EXT_DECLINED = 0,
    //    1    C0EA
    DSP_EXT_DECLINEDRM = 1,
    //2    C0D0
    DSP_EXT_APPROVED = 2,
    //    3    C0D1
    DSP_EXT_APPROVEDRM = 3,
    //    4    C0D2
    DSP_EXT_COMPLETE = 4,
    //   5    C0E4
    DSP_EXT_PROCESSING = 5,
    //  6    C0F8
    DSP_EXT_PROCESSING2 = 6,
    //    7    C0E5
    DSP_EXT_AUTHORISING2 = 7,
    // 8    C0E6
    DSP_EXT_NOTSUPPORTED = 8,
    //9    C0E7
    DSP_EXT_NOTSUPPORTEDRM = 9,
    // A    C0E8
    DSP_EXT_CARD_ERROR = 10,
    // B    C0E9
    DSP_EXT_CARD_ERRORRM = 11,
    // C    C0E3
    DSP_EXT_NOT_ACCEPTED = 12,
    // D    C0EA
    DSP_EXT_NOT_ACCEPTEDRM = 13,
    // E    C0EB
    DSP_EXT_CANCELED = 14,
    //F    C0EC
    DSP_EXT_CANCELEDRM = 15
} ;

#endif /* RuaPredifinedScreen_h */
