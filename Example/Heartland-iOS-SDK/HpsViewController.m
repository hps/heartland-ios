//
//  HpsViewController.m
//  Heartland-iOS-SDK
//
//  Created by Shaunti Fondrisi on 11/23/2015.
//  Copyright (c) 2015 Shaunti Fondrisi. All rights reserved.
//

#import "HpsViewController.h"
#import "hps.h"
 

@interface HpsViewController ()
{
    HpsTokenData *tokenResponse;
}
@property (weak, nonatomic) IBOutlet UILabel *chargeResultText;
@property (weak, nonatomic) IBOutlet UILabel *tokenResultText;
@property (weak, nonatomic) IBOutlet UILabel *tokenChargeResult;

@end

@implementation HpsViewController

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
- (IBAction)chargeCardTouched:(id)sender {
    
    /** NOTE: Do not include your gateway credentials in your application if you plan to distribute in the AppStore.
     This data can be easily obtained by decompiling the application on a jail broke phone. */

    // 1.) Configure the service
    HpsServicesConfig *config = [[HpsServicesConfig alloc]
                                 initWithSecretApiKey:@"skapi_cert_MYl2AQAowiQAbLp5JesGKh7QFkcizOP2jcX9BrEMqQ"
                                 developerId:@"123456"
                                 versionNumber:@"1234"];
    
    // 2.) Initialize the service
    HpsGatewayService *service = [[HpsGatewayService alloc] initWithConfig:config];
    
    // 3.) Initialize a Transaction to process
    HpsTransaction *transaction = [[HpsTransaction alloc] init];
    transaction.allowDuplicate = YES;
    //card holder data
    transaction.cardHolderData.firstName = @"Jane";
    transaction.cardHolderData.lastName = @"Doe";
    transaction.cardHolderData.address = @"123 Someway St.";
    transaction.cardHolderData.city = @"Anytown";
    transaction.cardHolderData.zip = @"AZ";
    
    //Card data as strings
    transaction.cardData.cardNumber = @"4242424242424242";
    transaction.cardData.expYear = @"2021";
    transaction.cardData.expMonth = @"6";
    
    //Do you want a re-use token returned? Or No.
    //Can be found on transaction.cardData.tokenResponse on the response block
    transaction.cardData.requestToken = YES;
    
    //charge details
    transaction.chargeAmount = 25.00f;
    
    //additional details (optional)
    transaction.additionalTxnFields.desc = @"Mega Sale";
    transaction.additionalTxnFields.invoiceNumber = @"12345";
    transaction.additionalTxnFields.customerID = @"4321";   
    
    // 4.) Run the transaction with the service.
    [service doTransaction:transaction
         withResponseBlock:^(HpsGatewayData *gatewayResponse, NSError *error) {
            
             
             if (error != nil) {
                 //Look in here for issues from the processor.
                 //gatewayResponse.gatewayResponseCode
                 //gatewayResponse.responseCode
                 
                 
             }
             self.chargeResultText.text = [NSString stringWithFormat:@"Response Code: %@\nResponse Text: %@", gatewayResponse.responseCode, gatewayResponse.responseText  ];
             
         }];
    
}
- (IBAction)getTokenTouched:(id)sender {
    HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:@"pkapi_cert_P6dRqs1LzfWJ6HgGVZ"];
    tokenResponse = nil;
    [service getTokenWithCardNumber:@"4242424242424242"
                                cvc:@"023"
                           expMonth:@"3"
                            expYear:@"2017"
                   andResponseBlock:^(HpsTokenData *response) {
                       
                       //saved for the charge.  Normally the token value is sent back to your server and you run a charge on it from the server to the gateway.
                       //The server would securely store your secret api keys to use on the charge.
                       tokenResponse = response;
                       self.tokenResultText.text = [NSString stringWithFormat:@"Token: %@", response.tokenValue];
                       
                   }];
    
    
    
}
- (IBAction)chargeTokenTouched:(id)sender {
    if (tokenResponse != nil) {
        
        /** NOTE: Do not include your gateway credentials in your application if you plan to distribute in the AppStore.
         This data can be easily obtained by decompiling the application on a jail broke phone. */
#warning Do not compile your SecretApiKey into the application
        
        // 1.) Configure the service
        HpsServicesConfig *config = [[HpsServicesConfig alloc]
                                     initWithSecretApiKey:@"skapi_cert_MYl2AQAowiQAbLp5JesGKh7QFkcizOP2jcX9BrEMqQ"
                                     developerId:@"123456"
                                     versionNumber:@"1234"];
        
        // 2.) Initialize the service
        HpsGatewayService *service = [[HpsGatewayService alloc] initWithConfig:config];
        
        // 3.) Initialize a Transaction to process
        HpsTransaction *transaction = [[HpsTransaction alloc] init];
        transaction.allowDuplicate = YES;
        
        //Charge Token
        transaction.cardData.tokenResponse = tokenResponse;
        
        //card holder data
        transaction.cardHolderData.firstName = @"Jane";
        transaction.cardHolderData.lastName = @"Doe";
        transaction.cardHolderData.address = @"123 Someway St.";
        transaction.cardHolderData.city = @"Anytown";
        transaction.cardHolderData.zip = @"AZ";
        
        //charge details
        transaction.chargeAmount = 25.00f;
        
        //additional details (optional)
        transaction.additionalTxnFields.desc = @"Mega Sale";
        transaction.additionalTxnFields.invoiceNumber = @"12345";
        transaction.additionalTxnFields.customerID = @"4321";
        
        // 4.) Run the transaction with the service.
        [service doTransaction:transaction
             withResponseBlock:^(HpsGatewayData *gatewayResponse, NSError *error) {
                 
                 if (error != nil) {
                     //Look in here for issues from the processor.
                     //gatewayResponse.gatewayResponseCode
                     //gatewayResponse.responseCode
                     
                     
                 }
                 self.tokenChargeResult.text = [NSString stringWithFormat:@"Response Code: %@\nResponse Text: %@", gatewayResponse.responseCode, gatewayResponse.responseText  ];
                 
             }];
        
    }else{
        self.tokenChargeResult.text = @"No token to charge";
    }
}

@end
