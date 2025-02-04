/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2019. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import "PairingViewController.h"
#import <RUALedPairingView.h>
#import "ConnectionListener.h"

@interface PairingViewController () <RUAPairingListener, RUADeviceStatusHandler>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *ledPairingViewContainer;
@property (weak, nonatomic) IBOutlet UIImageView *ledSequenceContainer;
@property (weak, nonatomic) IBOutlet UILabel *pairingStatus;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *pairButton;

@property (weak, nonatomic) IBOutlet UIButton *disconnectButton;

@end

@implementation PairingViewController
id<RUALedPairingConfirmationCallback> _ledConfirmationCb;
RUALedPairingView * _ledPairingView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [_statusLabel setText:@"Not Connected"];
    [_statusLabel setTextColor:UIColor.redColor];
    [_nameLabel setText: _selectedDevice.name];
    _ledPairingView  = [
                        [RUALedPairingView alloc]
                        initWithFrame:CGRectMake(
                                                 _ledSequenceContainer.frame.size.width/3,
                                                 _ledSequenceContainer.frame.size.height/9,
                                                 _ledSequenceContainer.frame.size.width/3,
                                                 _ledSequenceContainer.frame.size.width/12
                                                 )
                        ];
    [_ledSequenceContainer addSubview:_ledPairingView];
    [self hidePairingView];
    [_pairingStatus setHidden:YES];
    [_pairButton setHidden:NO];
    [_disconnectButton setHidden:YES];
    
    [[[RUA getDeviceManager:RUADeviceTypeMOBY5500] getConfigurationManager] activateDevice:_selectedDevice];
}

-(void) hidePairingView {
    [_ledPairingViewContainer setHidden:YES];
    [_ledPairingViewContainer setUserInteractionEnabled:NO];
}

-(void) showPairingView:(NSArray *) sequences {
    [_ledPairingViewContainer setHidden:NO];
    [_ledPairingViewContainer setUserInteractionEnabled:YES];
    [_ledPairingView showSequences:sequences];
    
}
 - (IBAction)pairReader:(id)sender {
     [_pairingStatus setHidden:YES];
     [[RUA getDeviceManager:RUADeviceTypeMOBY5500] initializeDevice:self pairingListener:self];
     [_pairButton setHidden:YES];
}

- (IBAction)confirmPairing:(id)sender {
    
    [_ledConfirmationCb confirm];
    
    [self hidePairingView];
    [_spinner startAnimating];
    [_pairingStatus setText:@"Pairing..."];
    [_pairingStatus setHidden:NO];
    [_pairingStatus setTextColor:UIColor.blackColor];
}


- (IBAction)cancelPairing:(id)sender {
    [_ledConfirmationCb cancel];
}

- (IBAction)restartPairing:(id)sender {
    [_ledConfirmationCb restartLedPairingSequence];
}

- (IBAction)disconnect:(id)sender {
    [[RUA getDeviceManager:RUADeviceTypeMOBY5500] releaseDevice];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:true completion:^{
        NSLog(@"REMOVING");
    }];
}

#pragma mark - RUADeviceStatusHandler

- (void)onConnected {
    [_statusLabel setText:@"Connected"];
    [_statusLabel setTextColor:UIColor.greenColor];
    [_disconnectButton setHidden:NO];
//    [_delegate onDeviceConnected];
}

- (void)onDisconnected {
    [_statusLabel setText:@"Not Connected"];
    [_statusLabel setTextColor:UIColor.redColor];
    [_pairButton setHidden:NO];
    [_disconnectButton setHidden:YES];
//    [_delegate onDeviceConnectionCancelled];
}

- (void)onError:(NSString *)message {
    [_statusLabel setText: message];
    [_statusLabel setTextColor:UIColor.redColor];
    [_pairButton setHidden:NO];
    [_disconnectButton setHidden:YES];
//    [_delegate onDeviceConnectionFailed];
}

#pragma mark - RUAPairingListener

- (void) onPairSucceeded {
    [_spinner stopAnimating];
    [_pairingStatus setText:@"Pairing Success!"];
    [_pairingStatus setHidden:NO];
    [_pairingStatus setTextColor:UIColor.greenColor];
//    [_delegate onDeviceConnected];
}

- (void) onPairNotSupported {
    [self hidePairingView];
    [_pairingStatus setText:@"Pairing Not Supported!"];
    [_pairingStatus setHidden:NO];
    [_pairingStatus setTextColor:UIColor.redColor];
    [_pairButton setHidden:NO];
//    [_delegate onDeviceConnectionFailed];
}

- (void) onPairFailed {
    [_spinner stopAnimating];
    [self hidePairingView];
    [_pairingStatus setText:@"Pairing Failed!"];
    [_pairingStatus setHidden:NO];
    [_pairingStatus setTextColor:UIColor.redColor];
    [_pairButton setHidden:NO];
//    [_delegate onDeviceConnectionFailed];
}

- (void) onPairCancelled {
    [_spinner stopAnimating];
    [self hidePairingView];
    [_pairingStatus setText:@"Pairing Cancelled!"];
    [_pairingStatus setHidden:NO];
    [_pairingStatus setTextColor:UIColor.redColor];
    [_pairButton setHidden:NO];
//    [_delegate onDeviceConnectionCancelled];
}

-(void)onLedPairSequenceConfirmation:(NSArray *)ledSequence confirmationCallback:(id<RUALedPairingConfirmationCallback>)confirmationCallback {
    
    _ledConfirmationCb = confirmationCallback;
    [self showPairingView:ledSequence];
}

@end
