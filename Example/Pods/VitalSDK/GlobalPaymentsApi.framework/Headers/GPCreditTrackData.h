#ifndef GPCreditTrackData_h
#define GPCreditTrackData_h

#import <Foundation/Foundation.h>
#import <GlobalPaymentsApi/GlobalPaymentsApi.h>

@interface GPCreditTrackData : GPCredit

@property (nonatomic) GPEntryMethod entryMethod;
@property (nonatomic, strong) NSString* value;

@end

#endif /* GPCreditTrackData_h */
