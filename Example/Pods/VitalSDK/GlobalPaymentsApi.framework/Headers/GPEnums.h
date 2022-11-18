#ifndef GPEnums_h
#define GPEnums_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GPAddressType) {
    GPAddressType_BillingAddress,
    GPAddressType_ShippingAddress,
};

//! Indicates the chip condition for failed EMV chip reads
//!
//! The default value is `GPEMVChipCondition_NoChipOrChipSuccess`, so there is no need to set the chip condition
//! manually in cases where there is no chip (e.g. MSR transactiions) or where the chip read is successful.
typedef NS_ENUM(NSInteger, GPEMVChipCondition) {
    //! No chip present or current chip read succeeded
    GPEMVChipCondition_NoChipOrChipSuccess,
    //! Current chip read failed but the previous transaction on the same device was either a successful chip read or was not a chip transaction.
    GPEMVChipCondition_ChipFailedPreviousSuccess,
    //! Current chip read failed and the previous transaction on the same device was also an unsuccessful chip read.
    GPEMVChipCondition_ChipFailedPreviousFailed,
};

typedef NS_ENUM(NSInteger, GPEntryMethod) {
    GPEntryMethod_Manual,
    GPEntryMethod_Swipe,
    GPEntryMethod_Proximity,
};

//! Indicates the tax type.
typedef NS_ENUM(NSInteger, GPTaxType) {
    //! Indicates tax was not used.
    GPTaxType_NotUsed,
    //! Indicates sales tax was applied.
    GPTaxType_SalesTax,
    //! Indicates tax exemption.
    GPTaxType_TaxExempt,
};

//! Indicates if a transaction should be specialized.
typedef NS_ENUM(NSInteger, GPTransactionModifier) {
    //! Indicates no specialization.
    GPTransactionModifier_None = 0,
    //! Indicates an incremental transaction.
    GPTransactionModifier_Incremental = 1 << 1,
    //! Indicates an additional transaction.
    GPTransactionModifier_Additional = 1 << 2,
    //! Indicates an offline transaction.
    GPTransactionModifier_Offline = 1 << 3,
    //! Indicates a commercial request transaction.
    GPTransactionModifier_LevelII = 1 << 4,
    //! Indicates a fraud decline transaction.
    GPTransactionModifier_FraudDecline = 1 << 5,
    //! Indicates a chip decline transaction.
    GPTransactionModifier_ChipDecline = 1 << 6,
    //! Indicates a cash back transaction.
    GPTransactionModifier_CashBack = 1 << 7,
    //! Indicates a voucher transaction.
    GPTransactionModifier_Voucher = 1 << 8,
    //! Indicates a consumer authentication (3DSecure) transaction.
    GPTransactionModifier_Secure3D = 1 << 9,
    //! Indicates a hosted payment transaction.
    GPTransactionModifier_HostedRequest = 1 << 10,
    //! Indicates a recurring transaction.
    GPTransactionModifier_Recurring = 1 << 11,
    //! Indicates a mobile transaction.
    GPTransactionModifier_EncryptedMobile = 1 << 12,
};

typedef NS_ENUM(NSInteger, GPTransactionType) {
    GPTransactionType_Decline = 0,
    GPTransactionType_Verify = 1 << 0,
    GPTransactionType_Capture = 1 << 1,
    GPTransactionType_Auth = 1 << 2,
    GPTransactionType_Refund = 1 << 3,
    GPTransactionType_Reversal = 1 << 4,
    GPTransactionType_Sale = 1 << 5,
    GPTransactionType_Edit = 1 << 6,
    GPTransactionType_Void = 1 << 7,
    GPTransactionType_AddValue = 1 << 8,
    GPTransactionType_Balance = 1 << 9,
    GPTransactionType_Activate = 1 << 10,
    GPTransactionType_Alias = 1 << 11,
    GPTransactionType_Replace = 1 << 12,
    GPTransactionType_Reward = 1 << 13,
    GPTransactionType_Deactivate = 1 << 14,
    GPTransactionType_BatchClose = 1 << 15,
};

typedef NS_ENUM(NSInteger, GPPaymentMethodType) {
    GPPaymentMethodType_Reference = 0,
    GPPaymentMethodType_Credit = 1 << 1,
    GPPaymentMethodType_Gift = 1 << 6,
};

#endif /* GPEnums_h */
