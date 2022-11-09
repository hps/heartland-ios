//
//  HRPAXTransactionViewController.m
//  Heartland-iOS-SDK_Example
//
//  Created by Desimini, Wilson on 7/9/21.
//  Copyright © 2021 Shaunti Fondrisi. All rights reserved.
//

#import "HRPAXTransactionViewController.h"
#import "HRPAXTransactionViewInput.h"

#warning temp - imports for binding
#import "HRPAXTransactionManager.h"
#import "HRPAXTransactionViewModel.h"

@interface HRPAXTransactionViewController () <HRPAXTransactionViewInput>

@property (weak, nonatomic) UILabel *statusLabel;
@property (weak, nonatomic) UIButton *saleButton;

@end

@implementation HRPAXTransactionViewController

// MARK: Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindPAXTransactionModule];
    [self configureSaleButton];
    [self configureStatusLabel];
}

// MARK: Lifecycle

#warning temp - binding module inside view controller for now
- (void)bindPAXTransactionModule {
    HRPAXTransactionManager *model = HRPAXTransactionManager.new;
    HRPAXTransactionViewModel *viewModel = HRPAXTransactionViewModel.new;
    HRPAXTransactionViewController *view = self;
    
    // inputs
    viewModel.model = model;
    view.viewModel = viewModel;
    
    // outputs
    model.output = viewModel;
    viewModel.output = view;
}

- (void)configureSaleButton {
    UIButton *button = UIButton.new;
    [button addTarget:self action:@selector(saleTapped) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = UIColor.systemBlueColor;
    [button setTitle:@"Sale" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:button];
    
    [NSLayoutConstraint activateConstraints:@[
        [button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [button.heightAnchor constraintEqualToConstant:52],
        [button.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:16],
        [button.widthAnchor constraintEqualToConstant:120],
    ]];
    
    _saleButton = button;
}

- (void)configureStatusLabel {
    UILabel *label = UILabel.new;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:label];
    
    [NSLayoutConstraint activateConstraints:@[
        [label.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-16],
        [label.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:16],
        [label.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-16],
        [label.topAnchor constraintEqualToAnchor:_saleButton.bottomAnchor constant:16],
    ]];
    
    _statusLabel = label;
}

// MARK: HRPAXTransactionViewInput

- (void)saleTapped {
    NSLog(@"saleTapepd");
    NSLog(@"_viewModel - %@", _viewModel);
    [_viewModel doTransaction];
}

// MARK: HRPAXTransactionViewModelOutput

- (void)showPAXTransactionCompleteWithPrompt:(nonnull NSString *)prompt {
    [_saleButton setUserInteractionEnabled:YES];
    _statusLabel.text = prompt;
}

- (void)showPAXTransactionInProgress {
    [_saleButton setUserInteractionEnabled:NO];
    _statusLabel.text = @"Transaction Pending";
}

@end
