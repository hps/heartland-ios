//
//  CommonManagerBase.h
//  MPOSCommunicationManager
//
//  Created by 1 on 2018/4/25.
//  Copyright © 2018 Landi 联迪. All rights reserved.
//

#import "CommunicationManagerBase.h"

@interface CommonManagerBase : CommunicationManagerBase

-(int)searchDevices:(id<DeviceSearchListener>)btsl;
-(int)searchDevices:(id<DeviceSearchListener>)btsl duration:(NSTimeInterval)timeout;

@end
