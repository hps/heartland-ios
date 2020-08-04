#import "HpsPaxLocalDetailReportBuilder.h"

@implementation HpsPaxLocalDetailReportBuilder

- (id)initWithDevice: (HpsPaxDevice*)paxDevice{
    self = [super init];
    if (self != nil)
    {
        device = paxDevice;
        
    }
    return self;
}
- (void) execute:(void(^)(HpsPaxLocalDetailResponse*, NSError*))responseBlock{   
    
    
    NSMutableArray *subgroups = [[NSMutableArray alloc] init];
    
    [self formSearchInput:self.searchCriteria];
    
    HpsPaxExtDataSubGroup *extData = [[HpsPaxExtDataSubGroup alloc] init];
    if ([PAX_SEARCH_CRITERIA_toString[self.searchCriteria] isEqualToString:PAX_SEARCH_CRITERIA_toString[MERCHANT_ID]] && self.searchData != nil) {
        [extData.collection setObject:self.searchData forKey:PAX_EXT_DATA_MERCHANT_ID];
    }
    
     if ([PAX_SEARCH_CRITERIA_toString[self.searchCriteria] isEqualToString:PAX_SEARCH_CRITERIA_toString[MERCHANT_NAME]] && self.searchData != nil) {
        [extData.collection setObject:self.searchData forKey:PAX_EXT_DATA_MERCHANT_NAME];
    }
    [subgroups addObject:extData];
    
    [device doReport:(NSString *)PAX_EDC_TYPE_ALL andSearchInput:_searchInput andSubGroups:subgroups withResponseBlock:^(HpsPaxLocalDetailResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            responseBlock(response, error);
        });
    }];
                
}
-(void)formSearchInput:(PAX_SEARCH_CRITERIA)searchCriteria
{
    _searchInput = [[NSMutableDictionary  alloc]initWithObjectsAndKeys:@"",PAX_SEARCH_CRITERIA_toString[TRANSACTION_TYPE],@"",PAX_SEARCH_CRITERIA_toString[CARD_TYPE],@"",PAX_SEARCH_CRITERIA_toString[RECORD_NUMBER],@"",PAX_SEARCH_CRITERIA_toString[TERMINAL_REFERENCE_NUMBER],@"",PAX_SEARCH_CRITERIA_toString[AUTH_CODE],@"",PAX_SEARCH_CRITERIA_toString[REFERENCE_NUMBER], nil];
    
    switch(searchCriteria) {
        case TRANSACTION_TYPE:
            [_searchInput setValue:self.searchData forKey:PAX_SEARCH_CRITERIA_toString[TRANSACTION_TYPE]];
            break;
        case CARD_TYPE:
            [_searchInput setValue:self.searchData forKey:PAX_SEARCH_CRITERIA_toString[CARD_TYPE]];
            break;
        case RECORD_NUMBER:
           [_searchInput setValue:self.searchData forKey:PAX_SEARCH_CRITERIA_toString[RECORD_NUMBER]];
            break;
        case TERMINAL_REFERENCE_NUMBER:
            [_searchInput setValue:self.searchData forKey:PAX_SEARCH_CRITERIA_toString[TERMINAL_REFERENCE_NUMBER]];
            break;
        case AUTH_CODE:
            [_searchInput setValue:self.searchData forKey:PAX_SEARCH_CRITERIA_toString[AUTH_CODE]];
            break;
        case REFERENCE_NUMBER:
            [_searchInput setValue:self.searchData forKey:PAX_SEARCH_CRITERIA_toString[REFERENCE_NUMBER]];
            break;
        default:
            break;
            
    }
}


                                                                            
@end
