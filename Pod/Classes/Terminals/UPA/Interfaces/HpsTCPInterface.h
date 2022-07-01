//
//  HpsTCPInterface.h
//  Heartland-iOS-SDK
//
//  Created by Desimini, Wilson on 7/1/22.
//

#import <Foundation/Foundation.h>

@protocol HpsTCPInterfaceDelegate <NSObject>

- (void)tcpInterfaceDidCloseStreams;
- (void)tcpInterfaceDidOpenStream;
- (void)tcpInterfaceDidReceiveStreamError:(NSError *)error;
- (void)tcpInterfaceDidReadData:(NSData *)data;
- (void)tcpInterfaceDidWriteData;

@end

@class HpsConnectionConfig;

@interface HpsTCPInterface : NSObject

@property (weak, nonatomic) id<HpsTCPInterfaceDelegate> delegate;
@property (strong, nonatomic) HpsConnectionConfig *config;

- (void)openConnection;
- (void)closeConnection;
- (void)sendData:(NSData *)data;
- (void)sendData:(NSData *)data onOpen:(BOOL)onOpen;
- (void)resetInputBuffer;
- (void)resetOutputBuffer;

@end
