//
//  ObjC.h
//  Heartland-iOS-SDK-SampleApp
//

#import <Foundation/Foundation.h>

@interface ObjC : NSObject

+ (BOOL)catchException:(void (NS_NOESCAPE ^)(NSError **))tryBlock error:(NSError **)error NS_REFINED_FOR_SWIFT;

@end
