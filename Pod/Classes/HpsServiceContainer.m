#import "HpsServiceContainer.h"

@implementation HpsServiceContainer

+ (id)sharedInstance {
	static HpsServiceContainer *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[self alloc] init];
	});
	return instance;
}

- (id)init {
	if (self = [super init]) {

		_configurations = [[NSMutableDictionary alloc]init];
	}
	return self;
}

-(void)configure:(HpsTableServiceConfiguration *)config
{
	[config Validate];
	[[HpsServiceContainer sharedInstance] configureService:config] ;
}

+(void)configureService :(HpsConfiguration *)config{

NSString *configName  = @"default";
	if (config) {
		if (!config.Validated) {
			[config Validate];
		}
	HpsConfiguredServices *cs = [[self sharedInstance] GetConfiguration:configName];
	[config ConfigureContainer:cs];
	[[self sharedInstance] addConfiguration:configName withConfigServices:cs];
}

}

-(void)addConfiguration:(NSString *)configName withConfigServices:(HpsConfiguredServices*) config{

	if ([self.configurations objectForKey:configName]) {
		_configurations[configName] = config;
	}
	else {
		[self.configurations setObject:config forKey:configName];
	}
}

-(HpsConfiguredServices*) GetConfiguration:(NSString *)configName{
	if([self.configurations objectForKey:configName]){
		NSLog(@"exist");
		return _configurations[configName];
	}
	NSLog(@"not exist");

	return [[HpsConfiguredServices alloc]init];
}

-(HpsTableServiceConnector *) GetTableServiceClient:(NSString *) configName {
	if ([_configurations objectForKey:configName]) {
	HpsConfiguredServices *configuredServices = _configurations[configName];
		
		return configuredServices.tableServiceConnector;
	}
	else
	{
		@throw [NSException exceptionWithName:@"HpsFreshTxtException" reason:@"The specified configuration has not been configured for table service." userInfo:nil];
	}
}

@end
