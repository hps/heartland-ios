#import <Foundation/Foundation.h>

@interface HpsBaseTableServiceResponse : NSObject

@property (nonatomic,assign) NSArray *messageIDs;
@property (nonatomic,assign) NSString *responseCode;
@property (nonatomic,assign) NSString *responseText;
@property (nonatomic,assign) NSString *Class;
@property (nonatomic,assign) NSString *action;
-(id)initWithResponseDictionary:(NSDictionary *)response;
-(void)mapResponse;
//-(NSString *)normalizeResponse:(NSString *)responseCode;

@end
