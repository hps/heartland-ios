#include "JsonDoc.h"

@implementation JsonDoc

- (instancetype) init
{
    self = [super init];
    _dict = [[NSMutableDictionary alloc] init];
    return self;
}

- (instancetype) initWithDictionary:(NSDictionary*)dict {
    self = [[JsonDoc alloc] init];
    _dict = [NSMutableDictionary dictionaryWithDictionary:dict];
    return self;
}

- (instancetype) remove:(NSString*)key
{
    [_dict removeObjectForKey:key];
    return self;
}

- (instancetype) set:(NSString*)key withValue:(NSObject*)value
{
    return [self set:key withValue:value force:false];
}

- (instancetype) set:(NSString*)key withValue:(NSObject*)value force:(BOOL)force
{
    [_dict setValue:value forKey:key];
    return self;
}

- (instancetype) subElement:(NSString*)key
{
    JsonDoc* doc = [[JsonDoc alloc] init];
    [_dict setValue:doc forKey:key];
    return doc;
}

- (NSString*) toString
{
    NSDictionary* finalizedDict = [self finalize];
    NSError *e = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:finalizedDict options:kNilOptions error:&e];

    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [str stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
}

- (NSDictionary*) finalize
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    for (NSString* key in _dict.allKeys) {
        NSObject* value = [_dict objectForKey:key];
        if ([value isKindOfClass:JsonDoc.class]) {
            value = [(JsonDoc*)value finalize];
        }
        [dict setValue:value forKey:key];
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (instancetype) get:(NSString*)key
{
    if ([self has:key]) {
        return [[JsonDoc alloc] initWithDictionary:[_dict objectForKey:key]];
    }

    return nil;
}

- (NSObject*) getValue:(NSString*)key
{
    return [_dict valueForKey:key];
}

- (BOOL) has:(NSString*)key
{
    return [_dict valueForKey:key] != nil;
}

- (NSString *) getValueAsString:(NSString *)key{
    NSObject* value = [self getValue:key];
    if (value == nil) {
        return nil;
    }

    return [NSString stringWithFormat:@"%@", value];
}

+ (instancetype) parse:(NSString*)json
{
    NSData* data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
    return [[JsonDoc alloc] initWithDictionary:dict];
}

@end
