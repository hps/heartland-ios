//
//  CardDataEnums.h
//  GlobalMobileSDK
//
//  Created by Govardhan Padamata on 8/2/20.
//  Copyright (c) 2020 GlobalPayments. All rights reserved.
//

#ifndef CardDataEnums_h
#define CardDataEnums_h

// TLV Related Enums
typedef NS_ENUM(NSUInteger, TagClass)
{
    TagClassUniversal = 0x00,
    TagClassApplication = 0x40,
    TagClassContextSpecific = 0x80,
    TagClassContextPrivate = 0xC0,
};

typedef NS_ENUM(NSUInteger, TagType)
{
    TagTypePrimitive = 0x00,
    TagTypeConstructed = 0x20
};

typedef NS_ENUM(NSUInteger, TagIdentfier)
{
    TagLeadingOctectLongIdentfier = 0x1F,
    TagTrailingIdentfierOctectHasNext = 0x80,
    TagTrailingIdentfierOctectIsLast = 0x00
};

typedef NS_ENUM(NSUInteger, BerLengthType)
{
    BerLengthTypeDefiniteShort,
    BerLengthTypeDefiniteLong,
    BerLengthTypeIndefinite
};

typedef NS_ENUM(NSUInteger, ParserPosition)
{
    ParserPositionTag,
    ParserPositionLength,
    ParserPositionValue
};

/**
 CardholderInteraction types :

 -  CardholderInteractionTypeEMVApplicationSelection: Multiple supported Applications (AIDs) are
    present on the inserted card and the cardholder must select which Application to process the payment

 -  CardholderInteractionTypeFinalAmountConfirmation: Cardholder must confirm the amount
    to be authorized prior to host processing takes place

 -  CardholderInteractionTypeCommercialCardDataEntry: Additional data was requested
    by the host because the processed card is a commercial card
 */
typedef NS_ENUM(NSUInteger, CardholderInteractionType)
{
    CardholderInteractionTypeEMVApplicationSelection,
    CardholderInteractionTypeFinalAmountConfirmation,
    CardholderInteractionTypeCommericalCardDataEntry
};

#endif /* CardDataEnums_h */
