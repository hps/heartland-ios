<a href="http://developer.heartlandpaymentsystems.com/SecureSubmit" target="_blank">
	<img src="http://developer.heartlandpaymentsystems.com/Resource/Download/sdk-readme-heartland-logo" alt="Heartland logo" title="Heartland" align="right" />
</a>

# Heartland iOS SDK

This SDK makes it easy to integrate your iOS apps with Heartland's [**Portico Gateway API**](http://developer.heartlandpaymentsystems.com/Portico). Supported features include:

* Card Not Present (eCommerce and mobile)
* Card Present (Retail and Restaurant)
* <a href="http://developer.heartlandpaymentsystems.com/SecureSubmit" target="_blank">Secure Submit</a> single-use tokenization and multi-use tokenization
* <a href="https://www.heartlandpaymentsystems.com/about-heartland-secure/" target="_blank">Heartland Secure</a> End-to-End Encryption (E3)
* [Credit](http://developer.heartlandpaymentsystems.com/Documentation/credit-card-payments/), [Gift & Loyalty](http://developer.heartlandpaymentsystems.com/Documentation/gift-card-payments/)</a>,and eCheck/ACH
* [Recurring Payments](http://developer.heartlandpaymentsystems.com/Documentation/recurring-payments/)


|  <a href="#data-security"><b>Data Security</b></a> | <a href="#documentation-and-examples"><b>API Reference</b></a>  |  <a href="#testing--certification"><b>Testing & <br>Certification</b></a> | <a href="#api-keys"><b>API Keys</b></a> | Links |
|:--:|:--:|:--:|:--:|:--|
| [![](http://developer.heartlandpaymentsystems.com/Resource/Download/sdk-readme-icon-secure)](#data-security)  | [![](http://developer.heartlandpaymentsystems.com/Resource/Download/sdk-readme-icon-resources)](#documentation-and-examples)  | [![](http://developer.heartlandpaymentsystems.com/Resource/Download/sdk-readme-icon-tools)](#testing--certification) | [![](http://developer.heartlandpaymentsystems.com/Resource/Download/sdk-readme-icon-keys)](#api-keys) | <a href="http://developer.heartlandpaymentsystems.com/Account/Register" target="_blank">Register an Account</a> <br> <a href="http://developer.heartlandpaymentsystems.com/Partnership" target="_blank">Partner with Heartland</a> <br>  |


#### Developer Support

You are not alone! If you have any questions while you are working through your development process, please feel free to <a href="https://developer.heartlandpaymentsystems.com/Support" target="_blank">reach out to our team for assistance</a>!


## Requirements

Adding this pod will also include the XMLDictionary, and Masonry cocoapod as a dependency.
 
 
## Installation

Heartland-iOS-SDK is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile and run "pod update":

```Objective-C
pod 'Heartland-iOS-SDK'
```

## For iOS 9 only: Whitelist heartlandportico.com

If you compile your app with iOS SDK 9.0 or above, you will be affected by App Transport Security. Currently, you will need to whitelist heartlandportico.com in your app by adding the following to your application's plist:

```Objective-C
<key>NSAppTransportSecurity</key>  
<dict>  
<key>NSExceptionDomains</key>  
    <dict>  
        <key>heartlandportico.com</key>  
        <dict>  
            <key>NSIncludesSubdomains</key>  
            <true/>  
            <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>  
            <true/>  
            <key>NSTemporaryExceptionMinimumTLSVersion</key>  
            <string>1.0</string>  
            <key>NSTemporaryExceptionRequiresForwardSecrecy</key>  
            <false/>  
        </dict>  
    </dict>  
</dict>  

```


## API Keys

<img src="http://developer.heartlandpaymentsystems.com/Resource/Download/sdk-readme-icon-keys" align="right"/>
Integrations that use card not present transactions, such as eCommerce web applications, will use API keys to authenticate. There are exceptions, such as card present POS integrations. For these projects please <a href="https://developer.heartlandpaymentsystems.com/Support" target="_blank">contact us</a> for more information.  

To begin creating test transactions you will need to obtain a set of public and private keys. These are easily obtained by creating an account on our [developer portal](http://developer.heartlandpaymentsystems.com/).
Your keys are located under your profile information. 

[![Developer Keys](http://developer.heartlandpaymentsystems.com/Resource/Download/sdk-readme-devportal-keys)](http://developer.heartlandpaymentsystems.com/Account/KeysAndCredentials)

You will use your public key when implementing card tokenization and your private key will be used when communicating with our Portico Gateway. More details can be found in our [documentation](http://developer.heartlandpaymentsystems.com/SecureSubmit).

Note: Multi-Use tokenization is not enabled by default when creating an account. You can contact <a href="mailto:SecureSubmitCert@e-hps.com?subject=Multi-use Token Request&body=Please enable multi-use tokens on my developer portal account which was signed up under the following email : ">Heartland's Specialty Products Team</a> to have this enabled. This is also true if you wish to use Gift & Loyalty, ACH, and Debit.






## Data Security
 
<img src="http://developer.heartlandpaymentsystems.com/Resource/Download/sdk-readme-icon-secure" align="right"/>
 If your app stores, processes, or transmits cardholder data in cleartext then it is in-scope for <a href="https://www.pcisecuritystandards.org/document_library?category=padss" target="_blank">PA-DSS</a>. If your app is hosted, or the data in question otherwise comes into your organization, then the app and your entire company are in-scope for <a href="https://www.pcisecuritystandards.org/document_library?document=pci_dss" target="_blank">PCI DSS</a> (either as a merchant or a service provider). Heartland offers a suite of solutions to help keep integrators' applications and/or environments shielded from cardholder data, whether it motion or at rest.
 
 * **Secure Submit** for eCommerce web or mobile applications ("card-not-present"), which leverages single-use tokenization to prevent card data from passing through the merchant or integrator's webserver. It only requires a simple JavaScript inclusion and provides two options for payment field hosting:
 
  * **Self-Hosted Fields** - this approach relies upon the standard, appropriately named, HTML form controls on the integrator's served web page.
  
  - **Heartland Hosted Fields** - this approach combines the Secure Submit service with iframes to handle presentation of the form fields and collection of sensitive data on Heartland servers. Since PCI version 3.1 the PCI Council and many QSAs advocate the iframe-based approach as enabling a merchant to more readily achieve PCI compliance via the simplified <a href="https://www.pcisecuritystandards.org/documents/PCI-DSS-v3_2-SAQ-A_EP.pdf" target="_blank">SAQ A-EP</a> form. Check out the CoalFire's [whitepaper](http://developer.heartlandpaymentsystems.com/Resource/Download/coalfire-white-paper) for more information.
  
 - **Heartland Secure** for card-present retailers, hospitality, and other "POS" applications, comprises three distinct security technologies working in concert:
  - **End-to-End Encryption** (E3) - combines symmetric and asymmetric cryptography to form an "Identity-Based Encryption" methodology which keeps cardholder data encrypted from the moment of the swipe.
  
  - **Tokenization** - replaces sensitive data values with non-sensitive representations which may be stored for recurring billing, future orders, etc.
  
  - **EMV** - though less about data security and more about fraud prevention, EMV or chip card technology guarantees the authenticity of the payment card and is thus an important concern for retailers.
 
 Depending on your (or your customers') payment acceptance environment, you may need to support one or more of these technologies in addition to this SDK. This SDK also supports the ability to submit cleartext card numbers as input, but any developer who does so will be expected to demonstrate compliance with PA-DSS. Likewise any third party integrator who is planning on handling cleartext card data on behalf of other merchants will be expected to demonstrate their PCI DSS compliance as a Service Provider prior to completing certification with Heartland.
 
 If you implement Secure Submit tokenization for your web or mobile application you will never have to deal with handling a card number - Heartland will take care of it for you and return a token to initiate the charge from your servers.
 
 Similarly, if you implement Heartland Secure with E3 (for both swiped and keyed entry methods) then your POS application will be out-of-scope for PA-DSS. Heartland Secure certified devices will only ever return E3 encrypted data which can safely be passed through your systems as input to this SDK. Heartland Secure devices include many popular models manufactured by PAX and Ingenico.
 
 
To summarize, when you create a `paymentMethod` using this SDK you have the following options for securely avoiding interaction with sensitive cardholder data:
 
* Card data (track or PAN) may be sent directly from a web browser to Heartland, returning a SecureSubmit single use token that is then sent to your server.
 
* Encrypted card data (track or PAN) may be obtained directly from a Heartland Secure device and passed to the SDK

 
## Documentation and Examples 

 <img src="http://developer.heartlandpaymentsystems.com/Resource/Download/sdk-readme-icon-resources" align="right"/>
  You can find the latest SDK documentation along with code examples on our [Developer Portal](http://developer.heartlandpaymentsystems.com/documentation).
  In addition you can find a working example in the SDK itself under the example folder. To run the example project, clone the repo, and run `pod install` from the Example directory first.


#### Heartland SecureSubmit Tokenization for iOS

This project makes it easy to convert sensitive card data to single-use payment tokens. You can use Objective-C or Swift with this library.

#### Using Swift 

In the pod file make sure use_frameworks! is in the top area:
```swift
 
platform :ios, '8.0'
use_frameworks!
pod ‘Heartland-iOS-SDK’
 
```

#### Swift Token Service

Below is an example of all that is required to convert sensitive card information into a single-use token.  The request is asynchronous so you can safely run this code on the UI thread.
```swift

import Heartland_iOS_SDK

let tokenService: HpsTokenService = HpsTokenService(publicKey:"skapi_cert_Mc-xxxxxxxxxxxxxxxxxxxxxx");

tokenService.getTokenWithCardNumber("XXXXXXXXXXXXX",
                               cvc: "123",
                               expMonth: "12",
                               expYear: "2016") { (tokenData) in
    

    //use token
    tokenData.tokenValue
    //Call method after execution to continue.
    
}


```

#### Swift Gateway Service

Below is an example of all that is required to run a card transaction directly.

```swift

/** NOTE: Do not include your gateway credentials in your application if you plan to distribute in the AppStore.
 This data can be easily obtained by decompiling the application on a jail broke phone. */
 
// 1.) Configure the service
let config: HpsServicesConfig = HpsServicesConfig(secretApiKey: "skapi_cert_Mc-xxxxxxxxxxxxxxxxxxxxxx", developerId: "xxxxxx", versionNumber: "xxxxxxxxx")

// 2.) Initialize the service
let service: HpsGatewayService = HpsGatewayService(config: config)

// 3.) Initialize a Transaction to process
let transaction: HpsTransaction = HpsTransaction()

transaction.allowDuplicate = true

//Test Data
transaction.cardHolderData.firstName = "Freddy"
transaction.cardHolderData.lastName = "Kruger"
transaction.cardHolderData.address = "xxxxxx Dallas Pkwy"
transaction.cardHolderData.city = "Plano"
transaction.cardHolderData.state = "TX"
transaction.cardHolderData.zip = "xxxxxxx"

transaction.cardData.cardNumber = "xxxxxxxxxxxxxxxx"
transaction.cardData.expYear = "2016"
transaction.cardData.expMonth = "12"
transaction.cardData.cvv2 = "123"

//Can be found on transaction.cardData.tokenResponse on the response block
transaction.cardData.requestToken = false

//charge details
transaction.chargeAmount = 17.01

// 4.) Run the transaction with the service.
service.doTransaction(transaction) { (gatewayResponse, error) -> Void in
    if error != nil{
        //Look in here for issues from the processor.
        // output response code
        print(error)
    
        
    }
    else{
       // let gatewayResponseCode = gatewayResponse.gatewayResponseCode
       // let responseCode = gatewayResponse.responseCode
    }
    
}
```

#### Objective-C Token Service

Below is an example of all that is required to convert sensitive card information into a single-use token.  The request is asynchronous so you can safely run this code on the UI thread.
```objective-c
HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:@"YOUR PUBLIC KEY GOES HERE"];

[service getTokenWithCardNumber:@"XXXXXXXXXXXXX"
                            cvc:@"012"
                       expMonth:@"3"
                        expYear:@"2017"
               andResponseBlock:^(HpsTokenData *tokenResponse) {
                   
                   if([tokenResponse.type isEqualToString:@"error"]) {
                        self.tokenCodeResultLabel.text = tokenResponse.code;
                        self.tokenResultLabel.text = tokenResponse.message;
                   }
                   else {
                        self.tokenResultLabel.text = tokenResponse.tokenValue;
                   }
                   
               }];
```

#### Objective-C Gateway Service

Below is an example of all that is required to run a card transaction directly.


```objective-c
// 1.) Configure the service
HpsServicesConfig *config = [[HpsServicesConfig alloc]
                             initWithSecretApiKey: mySuperSecretKey
                             developerId: @"123456"
                             versionNumber: @"1234"];

// 2.) Initialize the service
HpsGatewayService *service = [[HpsGatewayService alloc] initWithConfig:config];

// 3.) Initialize a Transaction to process
HpsTransaction *transaction = [[HpsTransaction alloc] init];

//card holder data
transaction.cardHolderData.firstName = @"Jane";
transaction.cardHolderData.lastName = @"Doe";
transaction.cardHolderData.address = @"123 Someway St.";
transaction.cardHolderData.city = @"Anytown";
transaction.cardHolderData.zip = @"AZ";


//***************************
//add the tokenResponse to charge against.
transaction.cardData.tokenResponse = tokenResponse;
//***************************

//***************************
//Or charge by using card data directly - Not the recommended way for processing. 
//transaction.cardData.cardNumber = @"XXXXXXXXXXXXX";
//transaction.cardData.expYear = @"2021";
//transaction.cardData.expMonth = @"6";
//***************************


//Do you want a re-use token returned?
transaction.cardData.requestToken = YES;

//charge details
transaction.chargeAmount = 24.50f;

//additional details (optional)
transaction.additionalTxnFields.desc = @"Mega Sale";
transaction.additionalTxnFields.invoiceNumber = @"12345";
transaction.additionalTxnFields.customerID = @"4321";

// 4.) Run the transaction with the service.
[service doTransaction:transaction
     withResponseBlock:^(HpsGatewayData *gatewayResponse, NSError *error) {
         
         if (error != nil) {
             
  
            //Houston we have a problem
             
            //You can look at the 
            //Processing error codes:

            // [error localizedDescription];
             

            //gatewayResponse.responseCode
            //gatewayResponse.responseText

            //gatewayResponse.gatewayResponseCode
            //gatewayResponse.gatewayResponseText
             
            
         }else{
            //success


         }
     }];

```

    
*Quick Tip*: The included [test suite](http://github.hps.com/DevPortal/Heartland-iOS-SDK/tree/master/Example/Tests) can be a great source of code samples for using the SDK!

## Testing & Certification

<img src="http://developer.heartlandpaymentsystems.com/Resource/Download/sdk-readme-icon-tools" align="right"/>
Testing your implementation in our Certification/Sandbox environment helps to identify and squash bugs before you begin processing transactions in the production environment. While you are encouraged to run as many test transactions as you can, Heartland provides a specific series of tests that you are required to complete before receiving Certification. Please <a href="mailto:SecureSubmitCert@e-hps.com?Subject=Certification Request&Body=I am ready to start certifying my integration! ">contact</a> Heartland in order to initiate a certification project. 


#### Test Card Data

The following card numbers are used by our Certification environment to verify that your tests worked. Note that while variations (such as 4111111111111111) will work for general testing the cards listed below are required to complete certification. For card present testing Heartland can provide you with EMV enabled test cards.

<table align="center">
	<thead>
		<tr>
			<th scope="col">Name</th>
			<th scope="col">Number</th>
			<th scope="col">Exp Month</th>
			<th scope="col">Exp Year</th>
			<th scope="col">CVV</th>
			<th scope="col">Address</th>
			<th scope="col">Zip</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Visa</td>
			<td>4012002000060016</td>
			<td>12</td>
			<td>2025</td>
			<td>123</td>
			<td>6860 Dallas Pkwy</td>
			<td>75024</td>
		</tr>
		<tr>
			<td>MasterCard</td>
			<td>5473500000000014</td>
			<td>12</td>
			<td>2025</td>
			<td>123</td>
			<td>6860 Dallas Pkwy</td>
			<td>75024</td>
		</tr>
		<tr>
			<td>Discover</td>
			<td>6011000990156527</td>
			<td>12</td>
			<td>2025</td>
			<td>123</td>
			<td>6860 Dallas Pkwy</td>
			<td>75024</td>
		</tr>
		<tr>
			<td>Amex</td>
			<td>372700699251018</td>
			<td>12</td>
			<td>2025</td>
			<td>1234</td>
			<td>6860 Dallas Pkwy</td>
			<td>75024</td>
		</tr>
		<tr>
			<td>JCB</td>
			<td>3566007770007321</td>
			<td>12</td>
			<td>2025</td>
			<td>123</td>
			<td>6860 Dallas Pkwy</td>
			<td>75024</td>
		</tr>
	</tbody>
</table>

#### Testing Exceptions

During your integration you will want to test for specific issuer responses such as 'Card Declined'. Because our sandbox does not actually reach out to issuers we have devised specific transaction amounts that will trigger  [issuer response codes](https://cert.api2.heartlandportico.com/Gateway/PorticoDevGuide/build/PorticoDeveloperGuide/Issuer%20Response%20Codes.html) and [gateway response codes](https://cert.api2.heartlandportico.com/Gateway/PorticoDevGuide/build/PorticoDeveloperGuide/Gateway%20Response%20Codes.html). Please <a href="mailto:SecureSubmitCert@e-hps.com?subject=Hard Coded Values Spreadsheet Request">contact</a> Heartland for a complete listing of values you can charge to simulate AVS, CVV and Transaction declines, errors, and other responses that you can catch in your code:

```objective-c
####Testing Exceptions

During your integration you will want to test for specific issuer responses such as 'Card Declined'. Because our sandbox does not actually reach out to issuers we have devised specific transaction amounts that will trigger  [issuer response codes](https://cert.api2.heartlandportico.com/Gateway/PorticoDevGuide/build/PorticoDeveloperGuide/Issuer%20Response%20Codes.html) and [gateway response codes](https://cert.api2.heartlandportico.com/Gateway/PorticoDevGuide/build/PorticoDeveloperGuide/Gateway%20Response%20Codes.html). Please <a href="mailto:SecureSubmitCert@e-hps.com?subject=Hard Coded Values Spreadsheet Request">contact</a> Heartland for a complete listing of values you can charge to simulate AVS, CVV and Transaction declines, errors, and other responses that you can catch in your code:

```objective-c
 [service doTransaction:transaction
        withResponseBlock:^(HpsGatewayData *gatewayResponse, NSError *error) {
            
            //Token success or errors
            //gatewayResponse.tokenResponse.code
         
            //Gateway success or errors
            //gatewayResponse.responseCode

            //System or connection errors
            //error
            
        }];
````


## Contributing

All our code is open sourced and we encourage fellow developers to contribute and help improve it!

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Ensure SDK tests are passing
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request


#### Included Test Suite

The included test suite can help ensure your contribution doesn't cause unexpected errors and is a terrific resource of working examples that you can reference. You can find the test As mentioned earlier, the [here](http://github.hps.com/DevPortal/Heartland-iOS-SDK/tree/master/Example/Tests).


## License

Heartland-iOS-SDK is available under the EULA license. See the LICENSE file for more info.
