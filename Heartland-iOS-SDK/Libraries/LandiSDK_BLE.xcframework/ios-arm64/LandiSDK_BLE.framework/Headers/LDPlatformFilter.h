//
//  LDPlatformFilter.h
//  MPOSCommunicationManager
//
//  Created by tangchaoxun on 22/11/2018.
//  Copyright © 2018 Landi 联迪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum{
    LD_PlatformFilterType_COMMON,  // Platfrom || subPlatform || FileType
    LD_PlatformFilterType_M3X,     // SubPlatform || HardwareConfig
}LD_PlatformFilterType;

@interface LDPlatformFilter : NSObject<NSCopying>

-(instancetype)initForCommon:(NSString*)platform subPlatform:(NSString*)subPlatform fileType:(NSString*)fileType;
-(instancetype)initForM3X:(NSString*)subPlatform hardwareConfig:(NSString*)hardwareConfig;
-(instancetype)initForM3X:(NSString*)platform subPlatform:(NSString*)subPlatform fileType:(NSString*)fileType hardwareConfig:(NSString*)hardwareConfig;

@property (assign, nonatomic) LD_PlatformFilterType FilterType;
@property (strong, nonatomic) NSString* Platform;
@property (strong, nonatomic) NSString* SubPlatform;
@property (strong, nonatomic) NSString* FileType;
@property (strong, nonatomic) NSString* HardwareConfig;

@end

NS_ASSUME_NONNULL_END
