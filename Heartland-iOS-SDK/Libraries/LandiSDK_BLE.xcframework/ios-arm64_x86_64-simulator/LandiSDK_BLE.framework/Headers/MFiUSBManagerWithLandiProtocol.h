//
//  MFiUSBManagerWithLandiProtocol.h
//  MPOSCommunicationManager
//
//  Created by 1 on 2018/4/30.
//  Copyright © 2018 Landi 联迪. All rights reserved.
//

#import "CommonManagerBase.h"

@interface MFiUSBManagerWithLandiProtocol : CommonManagerBase

+(id)allocWithZone:(NSZone *)zone;
+(MFiUSBManagerWithLandiProtocol*)sharedInstance;
-(id)copyWithZone:(NSZone*)zone;

@end
