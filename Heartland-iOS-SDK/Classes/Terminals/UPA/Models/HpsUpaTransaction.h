#import <Foundation/Foundation.h>

@interface HpsUpaTransaction : NSObject
@property (nonatomic,retain)NSString* amount;
@property (nonatomic,retain)NSString* authorizedAmount;
@property (nonatomic,retain)NSString* baseAmount;
@property (nonatomic,retain)NSString* taxAmount;
@property (nonatomic,retain)NSString* tipAmount;
@property (nonatomic,retain)NSString* totalAmount;
@property (nonatomic,retain)NSString* taxIndicator;
@property (nonatomic,retain)NSString* cashBackAmount;
@property (nonatomic,retain)NSString* invoiceNbr;
@property (nonatomic,retain)NSString* allowPartialAuth;
@property (nonatomic,retain)NSString* referenceNumber;
@property (nonatomic,retain)NSString* tranNo;
@property (nonatomic,retain)NSString* processCPC;
@property (nonatomic,retain)NSString* prescriptionAmount;
@property (nonatomic,retain)NSString* clinicAmount;
@property (nonatomic,retain)NSString* dentalAmount;
@property (nonatomic,retain)NSString* visionOpticalAmount;
@property (nonatomic,retain)NSString* preAuthAmount;

@end
