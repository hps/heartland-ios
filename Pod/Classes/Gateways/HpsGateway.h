//
//  HpsGateway.h
//  Pods
//
//  Created by anurag sharma on 04/04/18.
//
//

#import <Foundation/Foundation.h>
#import "HpsGatewayResponse.h"

@interface HpsGateway : NSObject

@property (nonatomic) NSMutableDictionary *headers;
@property (nonatomic,assign) NSInteger timeOut;
@property NSString * serviceUrl;
@property (readonly) NSString *contentType;

@end
