#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HpsCurrencyCodes) {
    HpsCurrencyCodes_USD = 0,
    HpsCurrencyCodes_POINTS = 1
};

typedef NS_ENUM(NSInteger, HpsItemChoiceType) {
    HpsItemChoiceType_Alias = 0,
    HpsItemChoiceType_CardNbr = 1,
    HpsItemChoiceType_TokenValue = 2,
    HpsItemChoiceType_TrackData = 3
};


@interface HpsGiftCard : NSObject

@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *pin;
@property (nonatomic) NSInteger itemChoiceType;

@end
