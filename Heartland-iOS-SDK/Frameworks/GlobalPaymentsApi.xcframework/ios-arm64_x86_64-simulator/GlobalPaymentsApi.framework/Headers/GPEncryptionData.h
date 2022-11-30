#ifndef GPEncryptionData_h
#define GPEncryptionData_h

#import <Foundation/Foundation.h>

@interface GPEncryptionData : NSObject

@property (nonatomic, strong) NSString* version;
@property (nonatomic, strong) NSString* trackNumber;
@property (nonatomic, strong) NSString* ksn;
@property (nonatomic, strong) NSString* ktb;

@end

#endif /* GPEncryptionData_h */
