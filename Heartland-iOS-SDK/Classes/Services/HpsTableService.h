#import <Foundation/Foundation.h>
#import "HpsTableServiceConfiguration.h"
#import "HpsLoginResponse.h"
#import "HpsTicket.h"
#import "HpsServiceContainer.h"
#import "HpsTableServiceResponse.h"
#import "HpsTableServiceConnector.h"
#import "HpsServerListResponse.h"
#import "HpsServerAssignmentResponse.h"
#import "HpsServerListResponse.h"
#import "NSMutableDictionary+ShiftAssignments.h"

@interface HpsTableService : NSObject

@property HpsTableServiceConfiguration *config;
-(instancetype)initWithConfig:(HpsTableServiceConfiguration *)config;
-(void) LoginWithUserName:(NSString *) username withPassword:(NSString *) password withCompletion:(void(^)(HpsLoginResponse *, NSError*))responseBlock;
-(void) AssignCheckWithTableNumer:(NSInteger)tableNumber withCheckId:(NSInteger)checkId withCompletion:(void(^)( HpsTicket*, NSError*))responseBlock;
-(NSArray *)BumpStatuses;


//Server Assignment
-(void)GetServerAssignments:(void(^)(HpsServerAssignmentResponse *response, NSError* error))responseBlock;
-(void)GetServerAssignments:(NSString *)serverName withCompletion:(void(^)(HpsServerAssignmentResponse *response, NSError* error))responseBlock;
-(void)getServerAssignmemntsWithTableNumber:(NSInteger)tableNumber withCompletion:(void(^)(HpsServerAssignmentResponse *response, NSError* error))responseBlock;

//ServerList Operations
-(void)GetServerList:(void(^)(HpsServerListResponse *, NSError*))responseBlock;
-(void)UpdateServerList:(NSArray *)serverList withCompletion:(void(^)(HpsServerListResponse *, NSError*))responseBlock;

//Query Function
-(void) QueryCheckStatusWithCheckId:(NSInteger)checkID withCompletion:(void(^)(HpsTicket *, NSError*))responseBlock;
-(void)QueryTableStatusWithTableNumber:(NSInteger)tableNumber withCompletion:(void(^)(HpsTicket *, NSError*))responseBlock;

//Shift
-(void)AssignShift:(NSMutableDictionary *)shiftData withCompletion:(void(^)(HpsServerAssignmentResponse *response, NSError* error))responseBlock;

@end
