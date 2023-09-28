#ifndef GPDuplicateData_h
#define GPDuplicateData_h

#import <Foundation/Foundation.h>

@interface GPDuplicateData : NSObject

@property (nonatomic, strong) NSString* transactionId;
@property (nonatomic, strong) NSString* hostResponseDate;
@property (nonatomic, strong) NSString* clientTransactionId;
@property (nonatomic, strong) NSString* uniqueDeviceId;
@property (nonatomic, strong) NSString* globalTransactionId;
@property (nonatomic, strong) NSString* authorizationCode;
@property (nonatomic, strong) NSString* referenceNumber;
@property (nonatomic, strong) NSString* authorizedAmount;
@property (nonatomic, strong) NSString* cardType;
@property (nonatomic, strong) NSString* cardLast4;

@end

#endif /* GPDuplicateData_h */
