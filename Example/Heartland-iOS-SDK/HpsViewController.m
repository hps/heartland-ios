//
//  HpsViewController.m
//  Heartland-iOS-SDK
//
//  Created by Shaunti Fondrisi on 11/23/2015.
//  Copyright (c) 2015 Shaunti Fondrisi. All rights reserved.
//

#import "HpsViewController.h"
#import "Hps.h"

@interface HpsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *amountText;

@end

@implementation HpsViewController

- (IBAction)chargeTouched:(id)sender {
    
//    HpsCardEntry *cardEntry = [[HpsCardEntry alloc] init];
//    [cardEntry showCardEntryForKey:@"pkapi_cert_MDwOwJ8yEUeed4AZXu"
//          withNavigationController:self.navigationController
//                  andResponseBlock:^(HpsTokenResponse *response) {
//                      
//                      NSLog(@"response: %@", [response description]);
//                      NSLog(@"Token: %@", response.tokenValue);
//                      
//                      
//                      
//                  }];

}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
