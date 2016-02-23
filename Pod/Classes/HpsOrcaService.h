//
//  HpsOrcaService.h
//  Pods
//
//  Created by Shaunti Fondrisi on 2/10/16.
//
//

#import <Foundation/Foundation.h>
#import "HpsDeviceData.h"
#import "HpsCommon.h"

@class HpsServicesConfig;

@interface HpsOrcaService : NSObject


- (void) deviceActivationRequest:(HpsDeviceData*)device
                      withConfig:(HpsServicesConfig*)config
                andResponseBlock:(void(^)(HpsDeviceData*, NSError*))responseBlock;

- (void) activeDevice:(HpsDeviceData*)device
           withConfig:(HpsServicesConfig*)config
     andResponseBlock:(void(^)(HpsDeviceData*, NSError*))responseBlock;

- (void) getDeviceAPIKey:(HpsServicesConfig*)config
        andResponseBlock:(void(^)(NSString*, NSError*))responseBlock;

- (void) getDeviceParameters:(HpsDeviceData*)device
                  withConfig:(HpsServicesConfig*)config
            andResponseBlock:(void(^)(NSDictionary*, NSError*))responseBlock;

@end
