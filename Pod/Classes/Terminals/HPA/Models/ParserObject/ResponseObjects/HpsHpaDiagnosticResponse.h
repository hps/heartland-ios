#import <Foundation/Foundation.h>
#import "Record.h"

@interface HpsHpaDiagnosticResponse : NSObject

@property (nonatomic,strong) NSString *deviceId;
@property (nonatomic,strong) NSString *responseCode;
@property (nonatomic,strong) NSString *responseText;
@property (nonatomic,strong) NSMutableDictionary *commandRecord;
@property (nonatomic,strong) NSMutableDictionary *interfaceErrorRecord;
@property (nonatomic,strong) NSMutableArray *rebootLogRecord;

-(id)initWithResponse:(NSData *)data;
@end


