#import <Foundation/Foundation.h>

extern NSString * const EmploymentStatus_toString[];
extern NSString * const EmploymentCategory_toString[];
extern NSString * const MaritalStatus_toString[];
extern NSString * const Gender_toString[];
extern NSString * const FilterPayTypeCode_toString[];
extern NSString * const PayTypeCode_toString[];

typedef NS_ENUM(NSInteger, EmploymentStatus) {
    Active,
    Inactive,
    Terminated
};

typedef NS_ENUM(NSInteger, EmploymentCategory) {
    FullTime,
    PartTime
};

typedef NS_ENUM(NSInteger, MaritalStatus) {
    Married,
    Single
};

typedef NS_ENUM(NSInteger, Gender) {
    Female,
    Male
};

typedef NS_ENUM(NSInteger, FilterPayTypeCode) {
    Hourly,
    T1099,
	NONE
};

typedef NS_ENUM(NSInteger, PayTypeCode) {
    PayType_Hourly,
    Salary,
    PayType_T1099,
    T1099_Hourly,
    Commision,
    AutoHourly,
    ManualSalary
};

typedef NS_ENUM(NSInteger, PaymentMethodType) {
    Reference,
    Credit,
    Debit,
    Ebt,
    Cash,
    ACH,
    Gift,
    Recurring,
    Other,
    AltPayment
};

typedef NS_ENUM(NSInteger, EntryMethod) {
    Manual,
    Swipe,
    Proximity
};

typedef NS_ENUM(NSInteger, CvnPresenceIndicator) {
    Present,
    Illegible,
    NotOnCard,
    NotRequested
};

typedef NS_ENUM(NSInteger, RecurringSequence) {
	
    First,
    Subsequent,
    Last
};

typedef NS_ENUM(NSInteger, RecurringType) {

    FIXED,
    VARIABLE
};

typedef NS_ENUM(NSInteger, CurrencyType) {

    CURRENCY,
    POINTS,
    CASH_BENEFITS,
    FOODSTAMPS,
    VOUCHER
    
};

typedef NS_ENUM(NSInteger, AccountType) {
    Checking,
    Savings
};

typedef NS_ENUM(NSInteger, AliasAction) {
    CREATE,
    ADD,
    DELETE
};

typedef NS_ENUM(NSInteger, EmvChipCondition) {
    ChipFailedPreviousSuccess,
    ChipFailedPreviousFailed
};

typedef NS_ENUM(NSInteger, InquiryType) {
    FOODSTAMP,
    CASH
};

typedef NS_ENUM(NSInteger, AddressType) {
    Billing,
    Shipping
};

typedef NS_ENUM(NSInteger, TransactionType) {
    Decline,
    Verify,
    Capture,
    Auth,
    Refund,
    Reversal,
    Sale,
    Edit,
    Void,
    AddValue,
    Balance,
    Activate,
    Alias,
    Replace,
    Reward,
    Deactivate,
    BatchClose,
    Create,
    Delete,
    BenefitWithdrawal,
    Fetch,
    Search,
    Hold,
    Release,
    VerifyEnrolled,
    VerifySignature
};

typedef NS_ENUM(NSInteger, PayGroupFrequency) {
    Annually = 1,
    Quarterly = 4,
    Monthly = 12,
    SemiMonthly = 24,
    BiWeekly = 26,
    Weekly = 52
};

typedef NS_ENUM(NSInteger, TypeOfCard) {
	Visa = 1,
	MasterCard = 2,
	Amex = 3,
	Discover = 4,
	Jcb = 5,
	GiftCard = 6
};

@interface HpsEnum : NSObject

@end
