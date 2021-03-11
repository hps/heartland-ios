#import <UIKit/UIKit.h>
#import "HpsTokenData.h"

typedef void(^CallbackBlockType)(HpsTokenData*);

@interface HpsCardEntryViewController : UIViewController

@property(nonatomic, strong) NSString* publicKey;

- (void) setCallBackBlock:(void(^)(HpsTokenData*))block;

@end
