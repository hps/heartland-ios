#import <Foundation/Foundation.h>

@interface HpsAddress : NSObject

@property (nonatomic, strong) NSString* address;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* state;
@property (nonatomic, strong) NSString* zip;
@property (nonatomic, strong) NSString* country;

-(void)isZipcodeValid;

@end
