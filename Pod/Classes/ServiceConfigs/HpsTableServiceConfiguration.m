#import "HpsTableServiceConfiguration.h"

@implementation HpsTableServiceConfiguration

-(void)ConfigureContainer:(HpsConfiguredServices *)services{
	if (_tableServiceprovider == FreshText) {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			services.tableServiceConnector = [[HpsTableServiceConnector alloc]init];
			services.tableServiceConnector.serviceUrl  = @"https://www.freshtxt.com/api31/";
			services.tableServiceConnector.timeOut  = timeoutValue;

		});
}
}


- (void) Validate {
	[super Validate];
	if (!(self.tableServiceprovider == FreshText))
		@throw [NSException exceptionWithName:@"HpsFreshTxtException" reason:@"tableService Provider must be specified" userInfo:nil];
}

@end
