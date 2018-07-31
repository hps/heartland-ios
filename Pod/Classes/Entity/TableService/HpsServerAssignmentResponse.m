#import "HpsServerAssignmentResponse.h"

@implementation HpsServerAssignmentResponse{
}
-(id)initWithResponseDictionary:(NSDictionary *)responseDictionary{
	if (self  = [super initWithResponseDictionary:responseDictionary]) {
		self.assignments = [[NSMutableDictionary alloc]init];
		[self AddAssignments:responseDictionary[@"data"]];
	}
	self.expectedAction = @"getServerAssignment";

	return self;
}

-(void)AddAssignments:(NSDictionary *)responseDictionary
{
	
[responseDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
	if ([key isEqualToString:@"row"] && [obj isKindOfClass:[NSArray class]] ) {
		NSLog(@"key = %@ Obj = %@",key,obj);
		for (int i = 0; i < [(NSArray*)obj count]; i ++) {
			NSDictionary *assignmentDetail = [obj objectAtIndex:i];
			NSLog(@"Assignment Detail = %@",assignmentDetail);
			NSString * tableString = assignmentDetail[@"tables"];
			tableString = [tableString stringByReplacingOccurrencesOfString:@"[(\n)]"
																  withString:@""
																	 options:NSRegularExpressionSearch
																	   range:NSMakeRange(0, tableString.length)];
			NSArray* arrayOfStrings = [tableString componentsSeparatedByString:@","];
			NSMutableArray* arrayOfNumbers = [NSMutableArray arrayWithCapacity:arrayOfStrings.count];
			for (NSString* string in arrayOfStrings) {
    [arrayOfNumbers addObject:[NSDecimalNumber decimalNumberWithString:string]];
			}
			[self.assignments setObject:arrayOfNumbers forKey:assignmentDetail[@"server"]];
		}
	}else if([key isEqualToString:@"row"] && [obj isKindOfClass:[NSDictionary class]]){
		NSLog(@"OBJECT = %@",obj);
		if (![obj objectForKey:@"resultSet"] && ![obj objectForKey:@"success"])
		[self.assignments setValue:obj[@"tables"] forKey:obj[@"server"]];
	}

}];

NSLog(@"*** Assignments = %@",self.assignments);
}

@end
