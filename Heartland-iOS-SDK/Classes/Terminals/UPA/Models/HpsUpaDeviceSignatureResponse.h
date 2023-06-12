//
//  HpsUpaDeviceSignatureResponse.h
//  Heartland-iOS-SDK
//

#import <Foundation/Foundation.h>

@class HpsUpaDeviceSignatureResponse;
@class HpsUpaDeviceSignatureResponseData;
@class HpsUpaCmdResult;
@class HpsUpaSignatureData;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface HpsUpaDeviceSignatureResponse : NSObject
@property (nonatomic, copy)   NSString *message;
@property (nonatomic, strong) HpsUpaDeviceSignatureResponseData *data;
@end

@interface HpsUpaDeviceSignatureResponseData : NSObject
@property (nonatomic, copy)   NSString *response;
@property (nonatomic, strong) HpsUpaCmdResult *cmdResult;
@property (nonatomic, strong) HpsUpaSignatureData *data;
@end

@interface HpsUpaCmdResult : NSObject
@property (nonatomic, copy) NSString *result;
@end

@interface HpsUpaSignatureData : NSObject
@property (nonatomic, copy) NSString *signatureData;
@end

NS_ASSUME_NONNULL_END
