//
//  HpsCardEntry.m
//  Copyright (c) 2015 Heartland Payment Systems. All rights reserved.
//
//  Created by Shaunti Fondrisi on 11/3/15.
//
//

#import "HpsCardEntry.h"
#import "HPSCardEntryViewController.h"

@implementation HpsCardEntry

- (void) showCardEntryForKey:(NSString*) publicKey withNavigationController:(UINavigationController*) navigationController andResponseBlock:(void(^)(HpsTokenResponse*))responseBlock
{
    //load a xib from a pod
    //credit: http://www.the-nerd.be/2015/08/07/load-assets-from-bundle-resources-in-cocoapods/
    
//    NSBundle *podBundle = [NSBundle bundleForClass:self.classForCoder];
//    NSURL *url = [podBundle URLForResource:@"Heartland-iOS-SDK" withExtension:@"bundle"];
//    
//    //xib bundle in the pod
//    NSBundle *bundle = [NSBundle bundleWithURL:url];
//    HpsCardEntryViewController *vc =  [[HpsCardEntryViewController alloc] initWithNibName:@"HPSCardEntryViewController" bundle:bundle];
//    
//    vc.publicKey = publicKey;
//    [navigationController presentViewController:vc animated:YES completion:nil];
//    
//    [vc setCallBackBlock:responseBlock];
}


- (void) showCardEntryForKey:(NSString*) publicKey inView:(UIView*) view andResponseBlock:(void(^)(HpsTokenResponse*))responseBlock
{
    //load a xib from a pod

    
    //Todo :: these are not visually correct after loading.  Moving to a code based approach.
    
//    NSBundle *podBundle = [NSBundle bundleForClass:self.classForCoder];
//    NSURL *url = [podBundle URLForResource:@"Heartland-iOS-SDK" withExtension:@"bundle"];
//    
//    //xib bundle in the pod
//    NSBundle *bundle = [NSBundle bundleWithURL:url];
//    HpsCardEntryViewController *vc =  [[HpsCardEntryViewController alloc] initWithNibName:@"HPSCardEntryViewController" bundle:bundle];
//    
//    vc.publicKey = publicKey;
//    [vc setCallBackBlock:responseBlock];
//    
//    vc.view.frame = view.frame;
//    [vc updateViewConstraints];
//    [view addSubview:vc.view];
    
}

@end
