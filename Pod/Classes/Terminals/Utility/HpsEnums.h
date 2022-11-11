#import <Foundation/Foundation.h>

extern NSString * const HpsStoredCardInitiator_toString[];

typedef NS_ENUM(NSInteger, HpsStoredCardInitiator) {
    HpsStoredCardInitiator_None,
    HpsStoredCardInitiator_Merchant,
    HpsStoredCardInitiator_CardHolder
};

@interface HpsEnums : NSObject

@end
