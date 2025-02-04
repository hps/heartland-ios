//
//  RUAE2EEMode.h
//  ROAMreaderUnifiedAPI
//
//  Created by Occ Mobility on 28/11/2022.
//  Copyright © 2022 ROAM. All rights reserved.
//

#ifndef RUAE2EEMode_h
#define RUAE2EEMode_h

typedef NS_ENUM (NSInteger, RUAE2EEMode) {
    RUAE2EEModeRoamdata3DesDukptCbc = 0,
    RUAE2EEModeOnguard = 1,
    RUAE2EEModeRsaOeap= 2,
    RUAE2EEModeRsaWallmart = 3,
    RUAE2EEModeRfu = 4,
    RUAE2EEModeWkPan = 5,
    RUAE2EEModeDukptPanOnly = 6,
    RUAE2EEModeRoamAes = 7,
    RUAE2EEModeTrack2Only = 8
} ;

#endif /* RUAE2EEMode_h */
