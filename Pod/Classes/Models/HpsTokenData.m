#import "HpsTokenData.h"

@implementation HpsTokenData

- (NSString*) toXML
{
    NSString *tokenValue = [NSString stringWithFormat:@"<hps:TokenValue>%@</hps:TokenValue>", self.tokenValue];
    return [NSString stringWithFormat:@"%@%@%@",@"<hps:TokenData>", tokenValue, @"</hps:TokenData>"];
}

@end
