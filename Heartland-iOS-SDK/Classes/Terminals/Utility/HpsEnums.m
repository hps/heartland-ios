#import "HpsEnums.h"

@implementation HpsEnums

NSString * const HpsStoredCardInitiator_toString[] = {
    [ HpsStoredCardInitiator_None ] = @"",
    [ HpsStoredCardInitiator_Merchant ] = @"M",
    [ HpsStoredCardInitiator_CardHolder ] = @"C",
};

@end
