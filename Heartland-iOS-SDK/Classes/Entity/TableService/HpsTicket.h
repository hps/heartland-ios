#import <Foundation/Foundation.h>
#import "HpsTableServiceResponse.h"

@interface HpsTicket : HpsTableServiceResponse

@property (nonatomic,assign)  NSInteger bumpStatusId ;
@property (nonatomic,assign) NSInteger checkId ;
@property (nonatomic,assign) NSDate *checkIntime ;
@property (nonatomic,assign) NSString  *partyName ;
@property (nonatomic,assign) NSInteger partyNumber ;
@property (nonatomic,assign) NSString *section ;
@property (nonatomic,assign)NSInteger tableNumber ;
@property (nonatomic,assign) NSInteger waitTime ;

-(instancetype)initWithDictionary:(NSDictionary *)response_dictionary ;

+  (HpsTicket *) FromId:(NSInteger ) checkId withTableNumber:(NSInteger)tableNumber;

	//OPEN ORDER
- (void) openOrderWithCompletion:(void(^)(HpsTableServiceResponse *, NSError*))responseBlock;
	//BUMP STAUS
-(void) bumpStatusWithStatus:(NSString *)bumpStatus withComplition:(void(^)(HpsTableServiceResponse *, NSError*))responseBlock ;
- (void ) bumpStatusWithBumpStatusId :(NSInteger )bumpStatusId withComplition:(void(^)(HpsTableServiceResponse *, NSError*))responseBlock;
	//SETTLE CHECK
- (void) settleCheck:(void(^)(HpsTableServiceResponse *, NSError*))responseBlock ;
- (void) settleCheckWithStatus:(NSString *)bumpStatus  withCompletion:(void(^)(HpsTableServiceResponse *, NSError*))responseBlock ;
- (void)  settleCheckwithID:(NSInteger ) bumpStatusId withCompletion:(void(^)(HpsTableServiceResponse *, NSError*))responseBlock;

	//CLEAR TABLE
- (void) clearTableWithComplition:(void(^)(HpsTableServiceResponse *, NSError*))responseBlock;
- (void) transferWithTableNumber:(NSInteger )newTableNumber withComplition:(void(^)(HpsTableServiceResponse *, NSError*))responseBlock;

- (void) updateWithComplition:(void(^)(HpsTableServiceResponse *, NSError*))responseBlock;

@end
