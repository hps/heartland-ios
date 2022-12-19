#import "HpsTableService.h"

@interface HpsTableService(){
	NSString *configName;
}
@end

@implementation HpsTableService

-(instancetype)initWithConfig:(HpsTableServiceConfiguration *)config{
	if (self = [super init]) {
		_config = config;
		configName  = @"default";

	}
	[HpsServiceContainer configureService:config];
	
	return self;
}

	/// <summary>
	/// String array of the bump statuses as reported by the table service API.
	/// </summary>
-(NSArray *)BumpStatuses{

	return [[[HpsServiceContainer sharedInstance]GetTableServiceClient:configName].bupStatusCollection.bumpstatus allKeys] ;
}

-(void)sendRequestwithEndPoint:(NSString *)endPoint withMultiPartForm:(NSDictionary *)formData withCompletion:(void(^)(NSDictionary *, NSError*))responseBlock
{
	HpsTableServiceConnector *connector = [[HpsServiceContainer sharedInstance] GetTableServiceClient:configName];
	[connector callWithEndPoint:endPoint withMultipartForm:formData withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
		responseBlock(responseDictionary,error);
	}];

}

	/// <summary>
	/// Used to log into the table service API and configure the connector for subsequent calls.
	/// </summary>
	/// <param name="username">Username of the user.</param>
	/// <param name="password">Password of the user.</param>
	/// <returns></returns>
-(void) LoginWithUserName:(NSString *) username withPassword:(NSString *) password withCompletion:(void(^)(HpsLoginResponse *, NSError*))responseBlock

{
	NSDictionary *content = @{@"username"     : username,
							 @"password"    : password,
							 };
	__weak NSString * weak_configName =  configName;
	[self sendRequestwithEndPoint:@"/user/login" withMultiPartForm:content withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
		if (error) {
			responseBlock(nil,error);

		}else{

		HpsLoginResponse *response = [[HpsLoginResponse alloc]initWithResponseDictionary:responseDictionary];
			HpsTableServiceConnector *connector = [[HpsServiceContainer sharedInstance] GetTableServiceClient:weak_configName];
			connector.sessionId = response.sessionId;
			connector.locationId = response.locationId;
			connector.securityToken = response.token;
			connector.bupStatusCollection = [[HpsBumpStatusCollection alloc]initWithBumpStatusCollectoion:response.tableStatus];
			responseBlock(response,nil);
		}
	}];
}

//	/// <summary>
//	/// This will assign a seated party with the specificied tabled number with a checkID from your POS. Practical uses
//	/// for this is when a server opens a check, your POS sends the tableNumber and checkID and Freshtxt returns
//	/// the party waitTime and checkInTime.This must be set to use any other POS API calls.
//	/// </summary>
//	/// <param name="tableNumber">table number to assign to the check</param>
//	/// <param name="checkId">ID of the check in the system</param>
//	/// <param name="startTime">optional: time the ticket was assigned.</param>
//	/// <returns>Ticket</returns>
-(void) AssignCheckWithTableNumer:(NSInteger)tableNumber withCheckId:(NSInteger)checkId withCompletion:(void(^)( HpsTicket*, NSError*))responseBlock
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
	NSDate *currentDate = [NSDate date];
	NSString *currentTime = [formatter stringFromDate:currentDate];

	NSDictionary *content = @{@"tableNumber"     : [NSString stringWithFormat:@"%ld",(long)tableNumber],
							  @"checkID"    : [NSString stringWithFormat:@"%ld",(long)checkId],
							  @"startTime" : currentTime
							  };
	[self sendRequestwithEndPoint:@"/pos/assignCheck" withMultiPartForm:content withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
		if (error) {
			responseBlock(nil,error);

		}else{
			HpsTicket *ticket = [[HpsTicket alloc]initWithDictionary:responseDictionary];
			ticket.tableNumber = tableNumber;
			responseBlock(ticket,nil);
		}
	}];
}

//	/// <summary>
//	/// Allows POS to query table/check status by table number. Occupied and enabled/disabled statuses are
//	/// returned, along with the checkID and bumpStatusID if a check is currently assigned.
//	/// </summary>
//	/// <param name="tableNumber">table number to query</param>
//	/// <returns>Ticket</returns>
-(void)QueryTableStatusWithTableNumber:(NSInteger)tableNumber withCompletion:(void(^)(HpsTicket *, NSError*))responseBlock{
	NSDictionary *content = @{@"tableNumber":[NSString stringWithFormat:@"%ld",(long)tableNumber]};
	[self sendRequestwithEndPoint:@"/pos/tableStatus" withMultiPartForm:content withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
		if (error) {
			responseBlock(nil,error);

		}else{
			HpsTicket *ticket = [[HpsTicket alloc]initWithDictionary:responseDictionary];
			responseBlock(ticket,nil);
		}
	}];
}

//	/// <summary>
//	/// Allows POS to query table/check status by table number. Occupied and enabled/disabled statuses are
//	/// returned, along with the checkID and bumpStatusID if a check is currently assigned.
//	/// </summary>
//	/// <param name="checkId">check id to query</param>
//	/// <returns>Ticket</returns>
-(void) QueryCheckStatusWithCheckId:(NSInteger)checkID withCompletion:(void(^)(HpsTicket *, NSError*))responseBlock{
		NSDictionary *content = @{@"checkID":[NSString stringWithFormat:@"%ld",(long)checkID]};
		[self sendRequestwithEndPoint:@"/pos/checkStatus" withMultiPartForm:content withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
			if (error) {
				responseBlock(nil,error);

			}else{
				HpsTicket *ticket = [[HpsTicket alloc]initWithDictionary:responseDictionary];
				responseBlock(ticket,nil);
			}
		}];
}

//	/// <summary>
//	/// Allows POS to get the current server list. Will return empty if no list is present.
//	/// </summary>
//	/// <returns>ServerListResponse</returns>
-(void)GetServerList:(void(^)(HpsServerListResponse *, NSError*))responseBlock{
		NSDictionary *content = @{};
	[self sendRequestwithEndPoint:@"/pos/getServerList" withMultiPartForm:content withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
		if (error) {
			responseBlock(nil,error);

		}else{
			HpsServerListResponse *response = [[HpsServerListResponse alloc]initWithResponseDictionary:responseDictionary];
			responseBlock(response,nil);
		}
	}];

}

//	/// <summary>
//	/// Allows POS to update the server name list inside Freshtxt. The complete list will be replaced with this method.
//	/// </summary>
//	/// <param name="serverList">Enumerable list of server names</param>
//	/// <returns>ServerListResponse</returns>
-(void)UpdateServerList:(NSArray *)serverList withCompletion:(void(^)(HpsServerListResponse *, NSError*))responseBlock{
	NSString *serverListToUpdate = [serverList componentsJoinedByString:@","];
	NSDictionary *content = @{@"serverList" : serverListToUpdate};
	
	[self sendRequestwithEndPoint:@"/pos/updateServerList" withMultiPartForm:content withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
		if (error) {
			responseBlock(nil,error);

		}else{

			[self GetServerList:^(HpsServerListResponse *response, NSError *error) {
	responseBlock(response,nil);

}];

	}
}];
}

//	/// <summary>
//	/// Allows POS to query for currently assigned tables to servers. Without the optional variables a complete list of
//	/// currently assigned servers along with their tables will be returned.If serverName is supplied, only the
//	/// tables assigned to that server will be returned. If tableNumber is supplied, only the server and other tables
//	/// assigned to that server will be returned.If both optional variables are supplied the server name will take
//	/// precedent.
//	/// </summary>
//	/// <returns>ServerAssignmentResponse</returns>
-(void)GetServerAssignments:(void(^)(HpsServerAssignmentResponse *response, NSError* error))responseBlock
{
	NSDictionary *content = @{};
	[self sendRequestwithEndPoint:@"/pos/getServerAssignment" withMultiPartForm:content withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
		if (error) {
			responseBlock(nil,error);

		}else{
			HpsServerAssignmentResponse *response = [[HpsServerAssignmentResponse alloc]initWithResponseDictionary:responseDictionary];
			responseBlock(response,nil);
		}
	}];
}

//	/// <summary>
//	/// Allows POS to query for currently assigned tables to servers. Without the optional variables a complete list of
//	/// currently assigned servers along with their tables will be returned.If serverName is supplied, only the
//	/// tables assigned to that server will be returned. If tableNumber is supplied, only the server and other tables
//	/// assigned to that server will be returned.If both optional variables are supplied the server name will take
//	/// precedent.
//	/// </summary>
//	/// <param name="serverName">server name to query</param>
//	/// <returns>ServerAssignmentResponse</returns>
-(void)GetServerAssignments:(NSString *)serverName withCompletion:(void(^)(HpsServerAssignmentResponse *response, NSError* error))responseBlock
{
	NSDictionary *content = @{@"serverName" : serverName};
	[self sendRequestwithEndPoint:@"/pos/getServerAssignment" withMultiPartForm:content withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
		if (error) {
			responseBlock(nil,error);

		}else{
			HpsServerAssignmentResponse *response = [[HpsServerAssignmentResponse alloc]initWithResponseDictionary:responseDictionary];
			responseBlock(response,nil);
		}
	}];
}

//	/// <summary>
//	/// Allows POS to query for currently assigned tables to servers. Without the optional variables a complete list of
//	/// currently assigned servers along with their tables will be returned.If serverName is supplied, only the
//	/// tables assigned to that server will be returned. If tableNumber is supplied, only the server and other tables
//	/// assigned to that server will be returned.If both optional variables are supplied the server name will take
//	/// precedent.
//	/// </summary>
//	/// <param name="tableNumber">table number to query server for</param>
//	/// <returns>ServerAssignmentResponse</returns>
-(void)getServerAssignmemntsWithTableNumber:(NSInteger)tableNumber withCompletion:(void(^)(HpsServerAssignmentResponse *response, NSError* error))responseBlock
{
	NSDictionary *content = @{@"tableNumber" : [NSString stringWithFormat:@"%ld",(long)tableNumber]};
	[self sendRequestwithEndPoint:@"/pos/getServerAssignment" withMultiPartForm:content withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
		if (error) {
			responseBlock(nil,error);

		}else{
			HpsServerAssignmentResponse *response = [[HpsServerAssignmentResponse alloc]initWithResponseDictionary:responseDictionary];
			responseBlock(response,nil);
		}
	}];
}

//	/// <summary>
//	/// Allows POS to assign and update shift data within Freshtxt. With this single call, new section/station
//	/// assignments can be made as well as server assignments to those sections.
//	/// </summary>
//	/// <param name="shiftData">Shift assignments object</param>
//	/// <returns>ServerAssignmentResponse</returns>
-(void)AssignShift:(NSMutableDictionary *)shiftData withCompletion:(void(^)(HpsServerAssignmentResponse *response, NSError* error))responseBlock{

	NSDictionary *content = @{@"shiftData" : [shiftData toString]};
	[self sendRequestwithEndPoint:@"/pos/assignShift" withMultiPartForm:content withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
		if (error) {
			responseBlock(nil,error);

		}else{
			HpsServerAssignmentResponse *response = [[HpsServerAssignmentResponse alloc]initWithResponseDictionary:responseDictionary];
			responseBlock(response,nil);
		}
	}];

}

@end
