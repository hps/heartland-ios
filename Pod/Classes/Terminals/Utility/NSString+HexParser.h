//
//  NSString+HexParser.h
//  Heartland-iOS-SDK
//
//  Created by Desimini, Wilson on 10/5/22.
//

#import <Foundation/Foundation.h>

@interface NSString (HexParser)

+ (instancetype)stringWithHex:(NSString *)hex;
- (instancetype)convertedFromHexadecimal;

@end
