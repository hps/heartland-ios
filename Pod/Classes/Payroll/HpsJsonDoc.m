#import "HpsJsonDoc.h"

@implementation HpsJsonDoc

-(id)init {
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.dict = [NSMutableDictionary new];
    self.keysArr = [NSArray new];
    
    return self;
}

-(id)init:(NSMutableDictionary*)dict withEncoder:(id<IRequestEncoder>)encoder {
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.dict = dict;
    self.encoder = encoder;
    
    return self;
}

-(HpsJsonDoc*)remove:(NSString*)key {
    
    [self.dict removeObjectForKey:key];
    
    return self;
}

-(HpsJsonDoc*)set:(NSString*)key withValue:(id)value and:(BOOL)force {
    
    if (_encoder != nil) {
        [self.dict setObject:[_encoder encode:value]  forKey:key];
    }
    else {
        [self.dict setObject:value forKey:key];
    }
    return self;
}

-(HpsJsonDoc*)subElement:(NSString *)name {
    
    HpsJsonDoc *subElementRef = [HpsJsonDoc new];
    [self.dict setObject:subElementRef forKey:name];
    return self;
}

-(NSString*)toString {
    
    NSMutableDictionary *final = [self finalise];
    NSError * err;
    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:final options:0 error:&err];
    NSString * jsonString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
    return jsonString;
}

-(NSMutableDictionary*)finalise {
    
    NSMutableDictionary *final = [NSMutableDictionary new];
    
    for (NSString* key in self.dict.allKeys) {
        if ([self.dict[key] isKindOfClass:[HpsJsonDoc class]]) {
            HpsJsonDoc *doc = (HpsJsonDoc *)self.dict[key];
            NSMutableDictionary *jsonDict = [doc finalise];
            [final setObject:jsonDict forKey:key];
        }
        else {
            [final setObject:self.dict[key] forKey:key];
        }
    }
    
    return final;
}

-(HpsJsonDoc*)get:(NSString*)name {
    if ([self.dict objectForKey:name]) {
        if ([self.dict[name] isKindOfClass:[HpsJsonDoc class]]) {
            HpsJsonDoc *doc = (HpsJsonDoc *)self.dict[name];
            return doc;
        }
        return nil;
    }
    return nil;
}

-(id)getValue:(NSString*)name {
    if (![[self.dict objectForKey:name] isKindOfClass:[NSNull class] ]) {
        return self.dict[name];
    }
    return nil;
}

-(id)getValue:(NSString *)name withEncoder:(id <IRequestEncoder>)encoder {

	id value = self.dict[name];
	if (self.encoder) {
		value = [self.encoder decode:value];
	}
	if(encoder){
		return [self.encoder encode:value];
	}else{
		return value;
	}
}

-(id)getEnumerator:(NSString*)name {
    if ([self.dict objectForKey:name]) {
        if ([[self.dict objectForKey:name] isKindOfClass:[NSArray class]]) {
            return [NSArray arrayWithArray:[self.dict objectForKey:name]];
        }
    }
    return nil;
}

-(NSArray*)getArray:(NSString*)name {
    
    if ([self.dict objectForKey:name] != nil) {
        if ([[self.dict objectForKey:name] isKindOfClass:[NSArray class]]) {
            return [self.dict objectForKey:name];
        }
    }
    return nil;
}

-(BOOL)has:(NSString*)name {
    if ([self.dict objectForKey:name] != nil) {
        return YES;
    }else {
        return NO;
    }
}

-(HpsJsonDoc*)parse:(NSString*)json withEncoder:(id<IRequestEncoder>)encoder {
    
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (jsonDict != nil) {
       return  [self parseObject:jsonDict withEncoder:encoder];
    }
    return nil;
}

-(id)parseSingleValue:(NSString*)json withName:(NSString*)name andEncoder:(id<IRequestEncoder>)encoder {
    
    HpsJsonDoc* jsonDoc = [self parse:json withEncoder:encoder];
    return [jsonDoc getValue:name];
}

-(HpsJsonDoc*)parseObject:(NSDictionary*)jsonDict withEncoder:(id<IRequestEncoder>)encoder {
    
    NSMutableDictionary* newDict = [NSMutableDictionary new];
    
    for (NSString* key in jsonDict.allKeys) {
        
        if ([[jsonDict objectForKey:key] isKindOfClass:[NSArray class]]) {
            
            NSArray* arr = [NSArray arrayWithArray:[jsonDict objectForKey:key]];
            
            if ([arr.firstObject isKindOfClass:[NSDictionary class]]) {
                NSArray *arrObj = [self parseObjectArray:arr andEncoder:encoder];
                [newDict setObject:arrObj forKey:key];
            }else {
                NSArray *arrObj = [self parseTypeArray:arr andEncoder:encoder];
                [newDict setObject:arrObj forKey:key];
            }
            
        }else if ([[jsonDict objectForKey:key] isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary* dictObj = [NSDictionary dictionaryWithDictionary:[jsonDict objectForKey:key]];
            [newDict setObject:[self parseObject:dictObj withEncoder:encoder] forKey:key];
        }else {
			
            [newDict setObject:[jsonDict objectForKey:key] forKey:key];
        }
    }


    
    HpsJsonDoc* jsonDoc = [[HpsJsonDoc alloc] init:newDict withEncoder:encoder];
    
    return jsonDoc;
}

-(NSMutableArray*)parseTypeArray:(NSArray*)jsonArr andEncoder:(id<IRequestEncoder>)encoder {
    
    NSMutableArray* response = [NSMutableArray new];
    
    for (id obj in jsonArr) {
        [response addObject:obj];
    }
    
    return response;
}

-(NSMutableArray*)parseObjectArray:(NSArray*)jsonArr andEncoder:(id<IRequestEncoder>)encoder {
    
    NSMutableArray* response = [NSMutableArray new];
    
    for (id obj in jsonArr) {
        [response addObject:[self parseObject:obj withEncoder:encoder]];
    }
    
    return response;
}


@end
