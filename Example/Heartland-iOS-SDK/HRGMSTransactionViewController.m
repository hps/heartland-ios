//
//  HRGMSTransactionViewController.m
//  Heartland-iOS-SDK_Example
//
//  Created by Desimini, Wilson on 6/17/21.
//  Copyright © 2021 Shaunti Fondrisi. All rights reserved.
//

#import "HRGMSTransactionViewController.h"
#import "HRGMSTransactionViewModel.h"

// MARK:- View Factory

@interface UIView (GMSTransactionViewFactory)

+ (UIButton *)buttonWithTitle:(NSString *)title;
+ (UILabel *)labelWithTitle:(NSString *)title;
+ (UILabel *)labelWithTitle:(NSString *)title flexibleHeight:(BOOL)flexibleHeight;

@end

@implementation UIView (GMSTransactionViewFactory)

+ (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *button = UIButton.new;
    button.backgroundColor = UIColor.systemBlueColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [button.heightAnchor constraintEqualToConstant:54],
        [button.widthAnchor constraintEqualToConstant:120],
    ]];
    
    return button;
}

+ (UILabel *)labelWithTitle:(NSString *)title {
    return [self labelWithTitle:title flexibleHeight:NO];
}

+ (UILabel *)labelWithTitle:(NSString *)title flexibleHeight:(BOOL)flexibleHeight {
    UILabel *label = UILabel.new;
    label.numberOfLines = 0;
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableArray *constraints = [NSMutableArray arrayWithArray:@[
        [label.widthAnchor constraintGreaterThanOrEqualToConstant:500]
    ]];
    
    if (!flexibleHeight) {
        [constraints addObject:[label.heightAnchor constraintEqualToConstant:44]];
    }
    
    [NSLayoutConstraint activateConstraints:constraints];
    
    return label;
}

@end

// MARK:- Transaction View Controller

@interface HRGMSTransactionViewController () <HRGMSTransactionView>

@property (strong, nonatomic) HRGMSTransactionViewModel *viewModel;
@property (weak, nonatomic) UILabel *responseBodyLabel;
@property (weak, nonatomic) UILabel *responseDescriptionLabel;
@property (weak, nonatomic) UIButton *returnButton;
@property (weak, nonatomic) UIButton *saleButton;
@property (weak, nonatomic) UILabel *statusLabel;

@end

@implementation HRGMSTransactionViewController

// MARK: Init

- (instancetype)init {
    self = [super init];
    if (self) {
        _viewModel = HRGMSTransactionViewModel.new;
        _viewModel.view = self;
    }
    return self;
}

// MARK: Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self configureTransactionViews];
}

// MARK: Lifecycle

- (void)addResponseBodyLabel {
    UILabel *responseLabel = [UILabel labelWithTitle:@"" flexibleHeight:YES];
    [self.view addSubview:responseLabel];
    _responseBodyLabel = responseLabel;
}

- (void)addResponseDescriptionLabel {
    UILabel *responseLabel = [UILabel labelWithTitle:@""];
    [self.view addSubview:responseLabel];
    _responseDescriptionLabel = responseLabel;
}

- (void)addReturnButton {
    UIButton *returnButton = [UIButton buttonWithTitle:@"Credit Return"];
    [returnButton addTarget:self action:@selector(creditReturnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnButton];
    _returnButton = returnButton;
}

- (void)addSaleButton {
    UIButton *saleButton = [UIButton buttonWithTitle:@"Credit Sale"];
    [saleButton addTarget:self action:@selector(creditSaleTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saleButton];
    _saleButton = saleButton;
}

- (void)addStatusLabel {
    UILabel *statusLabel = [UILabel labelWithTitle:@""];
    [self.view addSubview:statusLabel];
    _statusLabel = statusLabel;
}

- (void)configureTransactionViews {
    [self addResponseBodyLabel];
    [self addResponseDescriptionLabel];
    [self addStatusLabel];
    [self addReturnButton];
    [self addSaleButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [_statusLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:16],
        [_statusLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [_responseDescriptionLabel.topAnchor constraintEqualToAnchor:_statusLabel.bottomAnchor constant:16],
        [_responseDescriptionLabel.centerXAnchor constraintEqualToAnchor:_statusLabel.centerXAnchor],
        [_saleButton.topAnchor constraintEqualToAnchor:_responseDescriptionLabel.bottomAnchor constant:16],
        [_saleButton.centerXAnchor constraintEqualToAnchor:_responseDescriptionLabel.centerXAnchor],
        [_returnButton.topAnchor constraintEqualToAnchor:_saleButton.bottomAnchor constant:16],
        [_returnButton.centerXAnchor constraintEqualToAnchor:_saleButton.centerXAnchor],
        [_responseBodyLabel.topAnchor constraintEqualToAnchor:_returnButton.bottomAnchor constant:16],
        [_responseBodyLabel.centerXAnchor constraintEqualToAnchor:_saleButton.centerXAnchor],
        [_responseBodyLabel.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-16],
    ]];
}

// MARK: Actions

- (void)creditReturnTapped {
    [_viewModel gmsReturnSelected];
}

- (void)creditSaleTapped {
    [_viewModel gmsSaleSelected];
}

// MARK: HRGMSTransactionView

- (void)gmsTransactionViewDisplayResponseBody:(NSString *)bodyText {
    _responseBodyLabel.text = bodyText;
}

- (void)gmsTransactionViewDisplayResponseError:(NSString *)errorMessage {
    _responseDescriptionLabel.text = errorMessage;
}

- (void)gmsTransactionViewDisplayResponseSuccess {
    _responseDescriptionLabel.text = @"Success";
}

- (void)gmsTransactionViewDisplayStatus:(NSString *)status {
    _statusLabel.text = status;
}

- (void)gmsTransactionViewResetResponseViews {
    _responseBodyLabel.text = nil;
    _responseDescriptionLabel.text = nil;
    _statusLabel.text = nil;
}

@end
