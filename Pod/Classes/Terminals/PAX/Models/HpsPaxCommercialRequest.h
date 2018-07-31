#import <Foundation/Foundation.h>
#import "HpsTerminalEnums.h"
#import "HpsDeviceProtocols.h"

@interface HpsPaxCommercialRequest : NSObject <IHPSRequestSubGroup>

@property (nonatomic, strong) NSString* poNumber;
@property (nonatomic, strong) NSString* customerCode;
@property (nonatomic, strong) NSString* taxExempt;
@property (nonatomic, strong) NSString* taxExemptId;

- (NSString*) getElementString;

@end
