//
//  HpsUPAParser.m
//  Heartland-iOS-SDK
//
//  Created by Desimini, Wilson on 7/1/22.
//

#import "HpsUPAParser.h"
#import "HpsTerminalEnums.h"
#import "HpsUpaRequest.h"

@implementation HpsUPAParser

+ (NSData *)dataFromUPARaw:(NSData *)data {
    NSString *rawString = [[NSString alloc] initWithData:data
                                                encoding:NSASCIIStringEncoding];
    NSString *separator = [NSString stringWithFormat:
                           @"%c%c%c%c%c",
                           (char) HpsControlCodes_LF,
                           (char) HpsControlCodes_ETX,
                           (char) HpsControlCodes_LF,
                           (char) HpsControlCodes_STX,
                           (char) HpsControlCodes_LF];
    if ([rawString containsString:separator]) {
        NSArray *parts = [rawString componentsSeparatedByString:separator];
        rawString = parts[1];
    }
    NSCharacterSet *separatorCharSet = [NSCharacterSet characterSetWithCharactersInString:separator];
    rawString = [rawString stringByTrimmingCharactersInSet:separatorCharSet];
    return [rawString dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)jsonfromUPARaw:(NSData *)data {
    NSData *dataParsed = [self dataFromUPARaw:data];
    if (dataParsed == nil) return nil;
    return [NSJSONSerialization JSONObjectWithData:dataParsed options:0 error:nil];
}

+ (UPA_MSG_TYPE)messageTypeFromUPARaw:(NSString *)message {
    NSDictionary *upaMessageTypesByRaw = @{
        @"ACK": @(UPA_MSG_TYPE_ACK),
        @"NAK": @(UPA_MSG_TYPE_NAK),
        @"READY": @(UPA_MSG_TYPE_READY),
        @"BUSY": @(UPA_MSG_TYPE_BUSY),
        @"TO": @(UPA_MSG_TYPE_TIMEOUT),
        @"MSG": @(UPA_MSG_TYPE_MSG),
        @"DATA": @(UPA_MSG_TYPE_DATA), };
    NSNumber *typePointer = upaMessageTypesByRaw[message];
    return typePointer ? [typePointer longValue] : UPA_MSG_TYPE_UNKNOWN;
}

@end
