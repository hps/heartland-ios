#import <Foundation/Foundation.h>

@interface HpsPayrollConfig : NSObject

@property (nonatomic,assign) NSString* userName;
@property (nonatomic,assign) NSString* password;
@property (nonatomic,assign) NSString* apiKey;
@property (nonatomic, strong) NSString *serviceUrl;
@property (assign) NSInteger timeOut;

-(id)initWithUserName:(NSString *)userName withPassword:(NSString *)password withApiKey:(NSString *)apiKey withServiceUrl:(NSString *)serviceUrl withTimeout:(NSInteger)timeout;

@end
