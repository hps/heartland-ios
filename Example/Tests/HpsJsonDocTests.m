#import <XCTest/XCTest.h>
#import "JsonDoc.h"

@interface HpsJsonDocTests : XCTestCase

@end

@implementation HpsJsonDocTests

- (void) test_GetValue
{
    JsonDoc* doc = [[JsonDoc alloc] initWithDictionary:@{@"key1": @"value1"}];
    XCTAssertTrue([doc has:@"key1"]);
    NSString* value = (NSString*)[doc getValue:@"key1"];
    XCTAssertTrue([value isEqualToString:@"value1"]);
}

- (void) test_ToStringFlat
{
    JsonDoc* doc = [[JsonDoc alloc] initWithDictionary:@{@"key1": @"value1"}];
    NSString* value = [doc toString];
    XCTAssertTrue([value isEqualToString:@"{\"key1\":\"value1\"}"]);
}

- (void) test_ToStringNested
{
    JsonDoc* doc = [[JsonDoc alloc] initWithDictionary:@{@"key1": @"value1", @"key2": @{@"key3": @"value3"}}];
    NSString* value = [doc toString];
    XCTAssertTrue([value isEqualToString:@"{\"key1\":\"value1\",\"key2\":{\"key3\":\"value3\"}}"]);
}

- (void) test_ParseFlat
{
    JsonDoc* doc = [JsonDoc parse:@"{\"key1\": \"value1\"}"];
    NSString* value = (NSString*)[doc getValue:@"key1"];
    XCTAssertTrue([value isEqualToString:@"value1"]);
}

- (void) test_ParseNested
{
    JsonDoc* doc = [JsonDoc parse:@"{\"key1\":\"value1\",\"key2\":{\"key3\":\"value3\"}}"];
    NSString* value = (NSString*)[doc getValue:@"key1"];
    XCTAssertTrue([value isEqualToString:@"value1"]);
    NSDictionary* dict = (NSDictionary*)[doc get:@"key2"];
    value = (NSString*)[dict valueForKey:@"key3"];
    XCTAssertTrue([value isEqualToString:@"value3"]);
}

@end
