//
//  HpsTableServiceConfiguration.h
//  Pods
//
//  Created by anurag sharma on 06/04/18.
//
//

#import <Foundation/Foundation.h>
#import "HpsConfiguredServices.h"
#import "HpsConfiguration.h"

typedef NS_ENUM(NSInteger, HpsTableServiceProviders)
{
	FreshText
};
@interface HpsTableServiceConfiguration :HpsConfiguration

@property HpsTableServiceProviders tableServiceprovider;
	//-(instancetype)initWithTableServiceProvider:(HpsTableServiceProviders )provider;

@end
