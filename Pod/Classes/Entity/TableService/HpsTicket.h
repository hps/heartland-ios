//
//  HpsTicket.h
//  Pods
//
//  Created by anurag sharma on 04/04/18.
//
//

#import <Foundation/Foundation.h>
#import "HpsTableServiceResponse.h"

@interface HpsTicket : HpsTableServiceResponse
	/// <summary>
	/// The ID of the tables current bump status
	/// </summary>
@property (nonatomic,assign)  NSInteger bumpStatusId ;

	/// <summary>
	/// ID of the check associated with this ticket
	/// </summary>
@property (nonatomic,assign) NSInteger checkId ;

	/// <summary>
	/// Checkin time of the customer
	/// </summary>
@property (nonatomic,assign) NSDate *checkIntime ;

	/// <summary>
	/// Customer's party name
	/// </summary>
@property (nonatomic,assign) NSString  *partyName ;

	/// <summary>
	/// Number assigned to the customer's party
	/// </summary>
@property (nonatomic,assign) NSInteger partyNumber ;

	/// <summary>
	/// Section of the restaurant
	/// </summary>
@property (nonatomic,assign) NSString *section ;

	/// <summary>
	/// Table number associcated with this ticket/check
	/// </summary>
@property (nonatomic,assign)NSInteger tableNumber ;

	/// <summary>
	/// Time in minutes the customer has been waiting
	/// </summary>
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
