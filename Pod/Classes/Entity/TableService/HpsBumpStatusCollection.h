//
//  HpsBumpStatusCollection.h
//  Pods
//
//  Created by anurag sharma on 10/04/18.
//
//

#import <Foundation/Foundation.h>

@interface HpsBumpStatusCollection : NSObject
@property NSMutableDictionary  *bumpstatus;
-(id)initWithBumpStatusCollectoion:(NSString *)statusString;
@end
