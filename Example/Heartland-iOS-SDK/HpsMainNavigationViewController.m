//
//  HpsMainNavigationViewController.m
//  Heartland-iOS-SDK_Example
//
//  Created by Chibwe, Martin on 4/25/22.
//  Copyright © 2022 Shaunti Fondrisi. All rights reserved.
//

#import "HpsMainNavigationViewController.h"
#import "HpsConnectDeviceViewController.h"
@interface HpsMainNavigationViewController ()

@end

@implementation HpsMainNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)connectC2XDeviceButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"ConnectSegue" sender:self];
}
- (IBAction)cardEntryTransactionButtonTapped:(id)sender {
}
- (IBAction)deviceTransactionsButtonTapped:(id)sender {
}
- (IBAction)otaUpdateButtonTapped:(id)sender {
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ConnectSegue"]) {
        HpsConnectDeviceViewController *connect = [[HpsConnectDeviceViewController alloc] init];
        UINavigationController *nc = (UINavigationController *) segue.destinationViewController;
//       []
    }
    
    
}


@end
