#import "HpsClientInfo.h"

@implementation HpsClientInfo

-(id)init {

	self = [super init];

	if (self) {
		self.clientName = @"";
		self.clientCode = @"";
		self.federalEin = 0;
	}

	return self;
}

-(void)fromJSON:(HpsJsonDoc *)doc withArgument:(HpsPayrollEncoder *)encoder {
    _clientCode = [doc getValue:@"ClientCode"];
    _clientName = [doc getValue:@"ClientName"];
    _federalEin = (NSInteger)[doc getValue:@"FederalEin" withEncoder:encoder];
}

-(HpsPayRollRequest *)getClientInfoRequest:(HpsPayrollEncoder *)encoder
{
    HpsJsonDoc *request = [[HpsJsonDoc alloc]init];
    NSString *requestString =[[request set:@"FederalEin" withValue:[encoder encode:[NSString stringWithFormat:@"%ld",(long)_federalEin]] and:false] toString];
    
    return  [[HpsPayRollRequest alloc]initWithEndPoint:@"/api/pos/client/getclients" withRequestBody:requestString] ;
}

-(HpsPayRollRequest *)getCollectionRequestByType :(HpsPayrollEncoder *)encoder withType:(PayRollRequestType) request
{
    NSString *endPoint ;
    
    switch (request) {
        case TerminationReason:
            endPoint = @"/api/pos/termination/GetTerminationReasons";
            break;
        case WorkLocation:
            endPoint  = @"/api/pos/worklocation/GetWorkLocations";
            break;
        case LaborField:
            endPoint = @"/api/pos/laborField/GetLaborFields";
            break;
        case PayGroup:
            endPoint  = @"/api/pos/payGroup/GetPayGroups";
            break;
        case PayItem:
            endPoint  = @"/api/pos/payItem/GetPayItems";
            break;
        default:
            break;
    }
    
    HpsJsonDoc *jDOC = [[HpsJsonDoc alloc]init];
    NSString *requestString =[[jDOC set:@"ClientCode" withValue:[encoder encode:_clientCode] and:false] toString];
    return [[HpsPayRollRequest alloc]initWithEndPoint:endPoint withRequestBody:requestString];
}

@end
