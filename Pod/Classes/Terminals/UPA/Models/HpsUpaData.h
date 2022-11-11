#include "HpsUpaParams.h"
#include "HpsUpaTransaction.h"

@interface HpsUpaData : NSObject
@property (nonatomic,strong) HpsUpaParams* params;
@property (nonatomic,strong) HpsUpaTransaction* transaction;
@end
