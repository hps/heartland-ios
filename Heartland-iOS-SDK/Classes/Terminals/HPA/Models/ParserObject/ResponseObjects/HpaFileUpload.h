
#import <Foundation/Foundation.h>


@interface HpaFileUpload : NSObject

@property (nonatomic,strong) NSString *fileName;
@property (nonatomic,strong) NSString *hexData;
@property (nonatomic,assign) NSString *fileSize;

-(id)initWithFilePath:(NSString *)filePath;
@end

