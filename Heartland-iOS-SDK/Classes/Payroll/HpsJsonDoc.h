#import <Foundation/Foundation.h>
#import "HpsBase64Encoder.h"

@interface HpsJsonDoc : NSObject

@property (nonatomic, strong) NSMutableDictionary *dict;
@property id <IRequestEncoder> encoder;
@property (nonatomic, strong) NSArray *keysArr;

-(id)init:(NSMutableDictionary*)dict withEncoder:(id<IRequestEncoder>)encoder;
-(HpsJsonDoc *)subElement:(NSString *)name ;
-(NSString *)toString;
-(NSMutableDictionary *)finalise ;
-(HpsJsonDoc*)get:(NSString*)name;
-(id)getValue:(NSString*)name;
-(HpsJsonDoc*)set:(NSString*)key withValue:(id)value and:(BOOL)force;
-(id)getValue:(NSString *)name withEncoder:(id<IRequestEncoder>)encoder;
-(id)getEnumerator:(NSString*)name;
-(HpsJsonDoc*)parse:(NSString*)json withEncoder:(id<IRequestEncoder>)encoder;
-(id)parseSingleValue:(NSString*)json withName:(NSString*)name andEncoder:(id<IRequestEncoder>)encoder;

@end
