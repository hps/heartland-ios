#import <Foundation/Foundation.h>

@interface HpsAdditionalTxnFields : NSObject

@property (nonatomic, strong) NSString *invoiceNumber;
@property (nonatomic, strong) NSString *customerID;
@property (nonatomic, strong) NSString *desc;

- (NSString*) toXML;

@end
