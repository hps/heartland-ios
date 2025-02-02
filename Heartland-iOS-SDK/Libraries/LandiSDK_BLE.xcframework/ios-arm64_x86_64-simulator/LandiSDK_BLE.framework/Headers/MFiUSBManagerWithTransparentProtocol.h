//
//  MFiUSBManagerWithTransparentProtocol.h
//  MPOSCommunicationManager
//
//  Created by 1 on 2018/5/5.
//  Copyright © 2018 Landi 联迪. All rights reserved.
//

#import "CommonManagerBase.h"

@interface MFiUSBManagerWithTransparentProtocol : CommonManagerBase

+(id)allocWithZone:(NSZone *)zone;
+(MFiUSBManagerWithTransparentProtocol*)sharedInstance;
-(id)copyWithZone:(NSZone*)zone;

@end
