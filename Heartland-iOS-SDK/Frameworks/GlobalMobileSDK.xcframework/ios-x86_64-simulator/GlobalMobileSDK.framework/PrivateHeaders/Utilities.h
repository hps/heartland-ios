//
//  Utilities.h
//  GlobalMobileSDK
//
//  Created by Govardhan Padamata on 8/2/20.
//  Copyright (c) 2020 GlobalPayments. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMVTagDescriptor.h"

@class TLVObject;

@interface Utilities : NSObject

// These tags are not required by Portico, sending these might failure in transactions.
+ (nullable NSArray<NSString *> *)porticoBlackListedEmvTags;

// Get hex String From Enum
+ (nonnull NSString *)hexStringFromEMVTagEnum:(EMVTagDescriptor)hexNumber;

/**
Returns TRACK_2_EQUIVALENT_DATA_KSN from given Array of EMV Tags.

@param emvTags Array of |TLV Data objects
@return EMV_TAG_BBPOS_TRACK_2_EQUIVALENT_DATA_KSN value
*/
+ (nullable NSString *)fetchKsnEquivalentDataFromEmvTags:(nullable NSArray<TLVObject *> *)emvTags;

/**
 Returns TRACK_2_EQUIVALENT_DATA from given Array of EMV Tags.

 @param emvTags Array of |TLV Data objects
 @return EMV_TAG_BBPOS_TRACK_2_EQUIVALENT_DATA value
 */
+ (nullable NSString *)fetchTrack2EquivalentDataFromEmvTags:(nullable NSArray<TLVObject *> *)emvTags;

+ (NSArray *_Nullable)convertStringToByteArray:(NSString *_Nullable)string;

@end
