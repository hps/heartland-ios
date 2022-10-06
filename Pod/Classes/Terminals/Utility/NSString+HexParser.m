//
//  NSString+HexParser.m
//  Heartland-iOS-SDK
//
//  Created by Desimini, Wilson on 10/5/22.
//

#import "NSString+HexParser.h"

@implementation NSString (HexParser)

+ (instancetype)stringWithHex:(NSString *)hex {
    NSMutableString *temp = [[NSMutableString alloc] init];
    int i = 0;
    while (i < [hex length]) {
        NSString *hexChar = [hex substringWithRange:NSMakeRange(i, 2)];
        int value = 0;
        sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
        [temp appendFormat:@"%c", (char)value];
        i += 2;
    }
    return [NSString stringWithString:temp];
}

- (instancetype)convertedFromHexadecimal {
    return [NSString stringWithHex:self];
}

@end
