#import "HpsTicket.h"
#import "HpsTableServiceResponse.h"
#import "HpsServiceContainer.h"

@implementation HpsTicket

-(instancetype)initWithDictionary:(NSDictionary *)response_dictionary  {
	if (self = [super initWithResponseDictionary:response_dictionary]) {
			//super(json,@"default");
		_checkId = (NSInteger)response_dictionary[@"data"][@"row"][@"checkID"];
		_bumpStatusId = (NSInteger)response_dictionary[@"data"][@"row"][@"waitTime"];
		_checkIntime = response_dictionary[@"data"][@"row"][@"checkInTime"] ;
		
	}
	self.expectedAction = @"AssignCheck";
	self.configName = @"default";
	return self;
}

-(void) mapResponse{
}
	/// <summary>
	/// This generally would be used to notifiy Freshxt of the kitchen bump time. This will allow the host to see a color
	/// status change on a table.The bumpStatusID is the status ID inside freshtxt that you want to set the bump to
	/// be.This can be configured inside the freshtxt application and is returned with every login in the
	/// tableStatus variable.The first item in that list is ID= 1, next id ID= 2 and so on.Setting ID = 0 will clear the
	/// tableStatus back to none.
	/// </summary>
	/// <param name="bumpStatus">The string value of the bump status</param>
	/// <param name="bumpTime">optional: the time of the status change</param>
	/// <returns>TableServiceResponse</returns>

-(void) bumpStatusWithStatus:(NSString *)bumpStatus withComplition:(void(^)(HpsTableServiceResponse *, NSError*))responseBlock {
	NSString *bumpStatusValue = [[[HpsServiceContainer sharedInstance]GetTableServiceClient:@"default"].bupStatusCollection.bumpstatus objectForKey:bumpStatus];

		_bumpStatusId  =  bumpStatusValue.integerValue;
		NSLog(@"checking dic = %@",[[[HpsServiceContainer sharedInstance]GetTableServiceClient:@"default"].bupStatusCollection.bumpstatus objectForKey:bumpStatus]);
	if (_bumpStatusId == 0) {
		@throw [NSException exceptionWithName:@"HpsFreshTextException" reason:[NSString stringWithFormat:@"Unknown status value:%ld",(long)_bumpStatusId] userInfo:nil];
	}
[self bumpStatusWithBumpStatusId:_bumpStatusId withComplition:^(HpsTableServiceResponse *response, NSError *error) {
	responseBlock(response,error);
}];
}
	/// <summary>
	/// This generally would be used to notifiy Freshxt of the kitchen bump time. This will allow the host to see a color
	/// status change on a table.The bumpStatusID is the status ID inside freshtxt that you want to set the bump to
	/// be.This can be configured inside the freshtxt application and is returned with every login in the
	/// tableStatus variable.The first item in that list is ID= 1, next id ID= 2 and so on.Setting ID = 0 will clear the
	/// tableStatus back to none.
	/// </summary>
	/// <param name="bumpStatusId">The ID of the bump status</param>
	/// <param name="bumpTime">optional: the time of the status change</param>
	/// <returns>TableServiceResponse</returns>
- (void) bumpStatusWithBumpStatusId :(NSInteger )bumpStatusId withComplition:(void(^)(HpsTableServiceResponse *, NSError*))responseBlock
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
	NSDate *currentDate = [NSDate date];
	NSString *bumpTime = [formatter stringFromDate:currentDate];
	NSDictionary *content = @{
							  @"checkID"    : [NSString stringWithFormat:@"%ld",(long)self.checkId],
							  @"bumpTime" : bumpTime,
							  @"bumpStatusID" : [NSString stringWithFormat:@"%ld",(long)bumpStatusId]
							  };
	[self sendRequestwithEndPoint:@"/pos/bumpStatus" withMultiPartForm:content withCompletion:^(HpsTableServiceResponse *response, NSError *error) {
		responseBlock(response,error);
	}];
}

	/// <summary>
	/// Allows POS to update/clear the party from the table inside Freshtxt.
	/// </summary>
	/// <param name="clearTime">optional: Time the table was cleared</param>
	/// <returns>TableServiceResponse</returns>
- (void) clearTableWithComplition:(void(^)(HpsTableServiceResponse *, NSError*))responseBlock{

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
	NSDate *currentDate = [NSDate date];
	NSString *clearTime = [formatter stringFromDate:currentDate];
	NSDictionary *content = @{
							  @"checkID"    : [NSString stringWithFormat:@"%ld",(long)self.checkId],
							  @"clearTime" : clearTime
							  };

	[self sendRequestwithEndPoint:@"/pos/clearTable" withMultiPartForm:content withCompletion:^(HpsTableServiceResponse *response, NSError *error) {
		responseBlock(response,error);
	}];
}

	/// <summary>
	/// This would be used to notifiy Freshxt of the order placement time.
	/// </summary>
	/// <param name="openTime">optional: The order placement time</param>
	/// <returns>TableServiceResponse</returns>
- (void) openOrderWithCompletion:(void(^)(HpsTableServiceResponse *, NSError*))responseBlock
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
	NSDate *currentDate = [NSDate date];
	NSString *openTime = [formatter stringFromDate:currentDate];
	NSDictionary *content = @{
							  @"checkID"    : [NSString stringWithFormat:@"%ld",(long)self.checkId],
							  @"openTime" : openTime
							  };

	[self sendRequestwithEndPoint:@"/pos/openOrder" withMultiPartForm:content withCompletion:^(HpsTableServiceResponse *response, NSError *error) {
		responseBlock(response,error);
	}];
}

	/// <summary>
	/// Allow POS to settle the check within Freshtxt and optionally change the tableStatus. This will allow the host to
	/// see a color status change on a table.The bumpStatusID is the status ID inside freshtxt that you want to set the
	/// bump to be. This can be configured inside the freshtxt application and is returned with every login in the
	/// tableStatus variable.The first item in that list is ID= 1, next id ID= 2 and so on.Setting ID = 0 will clear the
	/// tableStatus back to none.
	/// </summary>
	/// <returns>TableServiceResponse</returns>
-(void) settleCheck:(void(^)(HpsTableServiceResponse *, NSError*))responseBlock {

	[self settleCheckWithStatus:@"" withCompletion:^(HpsTableServiceResponse *response, NSError *error) {
		responseBlock(response,error);
	}];
}
	/// <summary>
	/// Allow POS to settle the check within Freshtxt and optionally change the tableStatus. This will allow the host to
	/// see a color status change on a table.The bumpStatusID is the status ID inside freshtxt that you want to set the
	/// bump to be. This can be configured inside the freshtxt application and is returned with every login in the
	/// tableStatus variable.The first item in that list is ID= 1, next id ID= 2 and so on.Setting ID = 0 will clear the
	/// tableStatus back to none.
	/// </summary>
	/// <returns>TableServiceResponse</returns>

- (void) settleCheckWithStatus:(NSString *)bumpStatus withCompletion:(void(^)(HpsTableServiceResponse *, NSError*))responseBlock
{
	NSInteger bumpStatusId = 0;
	if (!((bumpStatus == nil) || [bumpStatus isEqualToString:@""]))
	{
			bumpStatusId = [NSString stringWithFormat:@"%@", [[[HpsServiceContainer sharedInstance]GetTableServiceClient:self.configName].bupStatusCollection.bumpstatus objectForKey:bumpStatus]].integerValue;


		if (bumpStatusId == 0)
		{
			@throw [NSException exceptionWithName:@"HpsFreshTextException" reason:[NSString stringWithFormat:@"Unknown status value:%ld",(long)_bumpStatusId] userInfo:nil];
		}else{
		}
	}
	[self settleCheckwithID:bumpStatusId withCompletion:^(HpsTableServiceResponse *response, NSError *error)
	{
		responseBlock(response,error);
	}];
}
	/// <summary>
	/// Allow POS to settle the check within Freshtxt and optionally change the tableStatus. This will allow the host to
	/// see a color status change on a table.The bumpStatusID is the status ID inside freshtxt that you want to set the
	/// bump to be. This can be configured inside the freshtxt application and is returned with every login in the
	/// tableStatus variable.The first item in that list is ID= 1, next id ID= 2 and so on.Setting ID = 0 will clear the
	/// tableStatus back to none.
	/// </summary>
	/// <returns>TableServiceResponse</returns>
- (void)  settleCheckwithID:(NSInteger ) bumpStatusId  withCompletion:(void(^)(HpsTableServiceResponse *, NSError*))responseBlock {

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
	NSDate *currentDate = [NSDate date];
	NSString *settleTime = [formatter stringFromDate:currentDate];
	NSDictionary *content = @{
							  @"checkID"    : [NSString stringWithFormat:@"%ld",(long)self.checkId],
							  @"settleTime" : settleTime,
							  @"bumpStatusID"    : [NSString stringWithFormat:@"%ld",(long)bumpStatusId],
							  };

	[self sendRequestwithEndPoint:@"/pos/settleCheck" withMultiPartForm:content withCompletion:^(HpsTableServiceResponse *response, NSError *error) {
		if (bumpStatusId) {
			self.bumpStatusId = bumpStatusId;
		}
		responseBlock(response,error);
	}];

}

	/// <summary>
	/// Allows POS to transfer a party from a table to another table number newTableNumber . This will preserve
	/// all data associated with that party.
	/// </summary>
	/// <param name="newTableNumber">The new table number to assign to the existing table</param>
	/// <returns>TableServiceResponse</returns>
- (void) transferWithTableNumber:(NSInteger )newTableNumber withComplition:(void(^)(HpsTableServiceResponse *response, NSError*error))responseBlock
{
	NSDictionary *content = @{
							  @"checkID"    : [NSString stringWithFormat:@"%ld",(long)self.checkId],
							  @"newTableNumber" : [NSString stringWithFormat:@"%ld",(long)newTableNumber],
							  };

	[self sendRequestwithEndPoint:@"/pos/transfer" withMultiPartForm:content withCompletion:^(HpsTableServiceResponse *response, NSError *error) {
		if ([response.responseCode isEqualToString:@"00"]) {
			self.tableNumber = newTableNumber;
		}
		responseBlock(response,error);
	}];

}

	/// <summary>
	/// Allows POS to alter the partyName, partyNum (covers), section, and bumpStatusID for a table.
	/// </summary>
	/// <returns>TableServiceResponse</returns>
- (void) updateWithComplition:(void(^)(HpsTableServiceResponse *, NSError*))responseBlock;
{
	NSDictionary *content = @{
							  @"checkID"    : [NSString stringWithFormat:@"%ld",(long)self.checkId],
							  @"partyName" : self.partyName,
							  @"partNum" : [NSString stringWithFormat:@"%ld",(long)self.partyNumber],
							  @"section" : self.section,
							  @"bumpStatusID"    : [NSString stringWithFormat:@"%ld",(long)self.bumpStatusId]
							  };

	[self sendRequestwithEndPoint:@"/pos/editTable" withMultiPartForm:content withCompletion:^(HpsTableServiceResponse *response, NSError *error) {

		responseBlock(response,error);
	}];

}

	/// <summary>
	/// Creates a Ticket object from an existing check/table number
	/// </summary>
	/// <param name="checkId">The check ID assigned to this ticket</param>
	/// <param name="tableNumber">optional: the table number assigned to the ticket.</param>
	/// <returns>Ticket</returns>
+  (HpsTicket *) FromId:(NSInteger ) checkId withTableNumber:(NSInteger)tableNumber {

	HpsTicket *ticket = [[HpsTicket alloc]init];
	ticket.checkId = checkId;
	ticket.tableNumber = tableNumber;
	ticket.configName = @"default";

	return ticket;
}

@end
