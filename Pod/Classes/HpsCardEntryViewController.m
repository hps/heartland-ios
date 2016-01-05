//
//  HPSCardEntryViewController.m
//  Heartland E-Cart
//
//  Created by Shaunti Fondrisi on 10/23/15.
//  Copyright © 2015 Heartland Payment Systems. All rights reserved.
//

#import "HpsCardEntryViewController.h"
#import "HpsTokenService.h"
#import "HpsTokenResponse.h"

@interface HpsCardEntryViewController ()
{
    CallbackBlockType responseBlock;
    UITextField *cardNumberText;
    UITextField *cardNameText;
    UITextField *cardCCVText;
    UITextField *cardExpiresText;
}


@end

@implementation HpsCardEntryViewController

- (void) setCallBackBlock:(void(^)(HpsTokenResponse*))block
{
    responseBlock = block;
    
}

- (IBAction)submitCardProcess:(id)sender {
    
    
        HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:self.publicKey];
    
        [service getTokenWithCardNumber:@"4242424242424242"
                                    cvc:@"123"
                               expMonth:@"12"
                                expYear:@"2017"
                       andResponseBlock:^(HpsTokenResponse *response) {
    
                           //NSLog(@"response: %@", [response description]);
                           [self dismissViewControllerAnimated:YES completion:nil];
                           dispatch_async(dispatch_get_main_queue(), ^{
                               responseBlock(response);
                           });
                       }];

    
}
- (IBAction)cancelCardProcess:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void) setupUI
{
    
//    self.cardCCVText = [[UITextField alloc] init];
//    [self.view addSubview:self.cardCCVText];
//    
//    
//    
//    
//    //Test data
//    self.cardNumberText.text = @"4242424242424242";
//    self.cardCCVText.text = @"123";
//    
//    self.cardExpiresText.text = @"9/27/2019";
//    
//    self.cardNameText.text = @"George of the Jungle";

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
