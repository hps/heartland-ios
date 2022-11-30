#ifndef GPAddress_h
#define GPAddress_h

#import <Foundation/Foundation.h>
#import <GlobalPaymentsApi/GPEnums.h>

@interface GPAddress : NSObject

@property (nonatomic) GPAddressType addressType;
@property (nonatomic, strong) NSString* streetAddress1;
@property (nonatomic, strong) NSString* streetAddress2;
@property (nonatomic, strong) NSString* streetAddress3;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* province;
@property (nonatomic, strong) NSString* postalCode;

- (void) setState:(NSString*)value;
- (NSString*) state;

@end

#endif /* GPAddress_h */
