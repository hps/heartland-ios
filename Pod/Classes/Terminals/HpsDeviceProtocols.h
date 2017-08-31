//  Copyright (c) 2016 Heartland Payment Systems. All rights reserved.

#import <Foundation/Foundation.h>

@protocol IHPSDeviceMessage
@required
-(NSData*) getSendBuffer;

- (id) initWithBuffer:(NSData*)buffer;
- (NSString*) toString;

@end

@protocol IHPSDeviceResponse
@required
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *command;
@property (nonatomic,strong) NSString *version;
@property (nonatomic,strong) NSString *deviceResponseCode;
@property (nonatomic,strong) NSString *deviceResponseMessage;

@end

@protocol IHPSDeviceCommInterface
@required

-(void) connect;
-(void) disconnect;
-(void) send:(id<IHPSDeviceMessage>)message andResponseBlock:(void(^)(NSData*, NSError*))responseBlock;

//@optional
@end


@protocol IHPSRequestSubGroup
@required

-(NSString*) getElementString;

//@optional
@end

@interface HpsDeviceProtocols : NSObject

@end
