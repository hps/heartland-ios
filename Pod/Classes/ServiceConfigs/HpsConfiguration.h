//
//  HpsConfiguration.h
//  Pods
//
//  Created by anurag sharma on 10/04/18.
//
//

#import <Foundation/Foundation.h>
#import "HpsConfiguredServices.h"

static NSInteger timeoutValue  = 65000;

@interface HpsConfiguration : NSObject

	/// <summary>
	/// Gateway service URL
	/// </summary>

@property  NSString *serviceUrl;

	/// <summary>
	/// Timeout value for gateway communication (in milliseconds)
	/// </summary>

@property Boolean Validated;

-(void) ConfigureContainer:(HpsConfiguredServices *)serives;
-(void) Validate;

@end
