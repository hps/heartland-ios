#ifndef JsonDoc_h
#define JsonDoc_h

@interface JsonDoc : NSObject
{
    NSMutableDictionary* _dict;
}

- (instancetype) init;
- (instancetype) initWithDictionary:(NSDictionary*)dict;
- (instancetype) remove:(NSString*)key;
- (instancetype) set:(NSString*)key withValue:(NSObject*)value;
- (instancetype) set:(NSString*)key withValue:(NSObject*)value force:(BOOL)force;
- (instancetype) subElement:(NSString*)key;
- (NSString*) toString;
- (NSDictionary*) finalize;
- (instancetype) get:(NSString*)key;
- (NSObject*) getValue:(NSString*)key;
- (BOOL) has:(NSString*)key;
- (NSString *) getValueAsString:(NSString *)key;
+ (instancetype) parse:(NSString*)json;

@end

#endif
