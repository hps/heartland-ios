//
//  TemCommunicationManager.h
//  ROAMreaderUnifiedAPI
//
//  Created by Occ Mobility on 09/05/2022.
//  Copyright © 2022 ROAM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TemLibrary/TemLibrary-swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface TemCommunicationManager : NSObject

+(TemCommunicationManager *)getInstance;

-(void) initTemWithIp : (NSString *) ip
                        andport : (int) port
                     andResultBlock : (void (^)(SandboxStatus))resultBlock;

-(void)createReaderContext:(NSString *)readerStateJson AndCompletionBlock : (void (^)(int))completionBlock;

-(void)updateReaderStateJson:(NSString *)readerStateJson AndCompletionBlock : (void (^)(int))completionBlock;

-(void) pollForUpdate : (void (^) (int)) completionBlock;

-(void) reportFirmwareStatus : (void (^) (int)) completionBlock;

-(void)isUpdateAvailable: (NSString *)deviceSerialNumber andResultBlock : (void (^)(BOOL))resultBlock;

-(void)getUpdateFilePath: (NSString *)deviceSerialNumber andResultBlock : (void (^)(NSString *))resultBlock;

-(void)getRkiFileName: (NSString *)deviceSerialNumber andResultBlock : (void (^)(NSString *))resultBlock;

@end

NS_ASSUME_NONNULL_END
