
#import <Foundation/Foundation.h>

@interface HpsTransactionDuplicate : NSObject

// Duplicate Transaction
@property (nonatomic,strong) NSString *duplicateReferenceNumber;
@property (nonatomic,strong) NSString *duplicateTranDate;
@property (nonatomic,strong) NSString *duplicateApprovalCode;
@property (nonatomic,strong) NSString *duplicateTotalAmount;
@property (nonatomic,strong) NSString *duplicateCardType;
@property (nonatomic,strong) NSString *duplicatePanLast4;

@end
