//
//  MFiUSBManagerWithTLVProtocol.h
//  MPOSCommunicationManager
//
//  Created by 1 on 2018/5/3.
//  Copyright © 2018 Landi 联迪. All rights reserved.
//

#import "CommonManagerBase.h"

@interface MFiUSBManagerWithTLVProtocol : CommonManagerBase

+(id)allocWithZone:(NSZone *)zone;
+(MFiUSBManagerWithTLVProtocol*)sharedInstance;
-(id)copyWithZone:(NSZone*)zone;

@end
