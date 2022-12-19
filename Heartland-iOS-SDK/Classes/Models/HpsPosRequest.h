#import <Foundation/Foundation.h>
#import "HpsHeader.h"
#import "HpsTransaction.h"
 
@interface HpsPosRequest : NSObject

@property (nonatomic, strong) HpsHeader *header;
@property (nonatomic, strong) HpsTransaction *transaction;

- (NSString*) toXML;

@end
