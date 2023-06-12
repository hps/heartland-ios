#import <Foundation/Foundation.h>

@interface HpsUpaParams : NSObject
@property (nonatomic,retain)NSString* clerkId;
@property (nonatomic,retain)NSString* tokenRequest;
@property (nonatomic,retain)NSString* tokenValue;
@property (nonatomic,retain)NSString* lineItemLeft;
@property (nonatomic,retain)NSString* lineItemRight;
@property (nonatomic,retain)NSString* cardOnFileIndicator;
@property (nonatomic,retain)NSString* cardBrandTransId;

@property (nonatomic,retain)NSString* prompt1;
@property (nonatomic,retain)NSString* displayOption;
@end
