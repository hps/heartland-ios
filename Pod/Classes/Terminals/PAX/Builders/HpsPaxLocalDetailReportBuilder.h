#import <Foundation/Foundation.h>
#import "HpsPaxDevice.h"
#import "HpsPaxLocalDetailResponse.h"

@interface HpsPaxLocalDetailReportBuilder : NSObject
{
  HpsPaxDevice *device;
}

@property (nonatomic, readwrite) int referenceNumber;
@property (nonatomic) PAX_SEARCH_CRITERIA searchCriteria;
@property (nonatomic, strong) NSString *searchData;
@property (nonatomic, strong) NSMutableDictionary *searchInput;

- (void) execute:(void(^)(HpsPaxLocalDetailResponse*, NSError*))responseBlock;
- (void) formSearchInput:(PAX_SEARCH_CRITERIA)searchCriteria;
- (id)initWithDevice: (HpsPaxDevice*)paxDevice;
@end

