#import "HpsCardEntryViewController.h"
#import "HpsTokenService.h"
#import "HpsTokenData.h"

@interface HpsCardEntryViewController ()
{
    CallbackBlockType responseBlock;
    UITextField *cardNumberText;
    UITextField *cardNameText;
    UITextField *cardCCVText;
    UITextField *cardExpiresMonthText;
    UITextField *cardExpiresYearText;
}

@property (strong, nonatomic) UIScrollView* scrollView;

@end

@implementation HpsCardEntryViewController
- (id)init {
    self = [super init];
    if (!self) return nil;
    
    [self setupUI];
    
    return self;
}
- (void) setCallBackBlock:(void(^)(HpsTokenData*))block
{
    responseBlock = block;
    
}
- (void)singleTap:(UITapGestureRecognizer*)sender {
    [self.scrollView scrollRectToVisible:sender.view.frame animated:YES];
};
- (IBAction)submitCardProcess:(id)sender {
    
    
        HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:self.publicKey];
    
        [service getTokenWithCardNumber:@"4242424242424242"
                                    cvc:@"123"
                               expMonth:@"12"
                                expYear:@"2017"
                       andResponseBlock:^(HpsTokenData *response) {
    
                           //NSLog(@"response: %@", [response description]);
                           [self dismissViewControllerAnimated:YES completion:nil];
                           dispatch_async(dispatch_get_main_queue(), ^{
                               self->responseBlock(response);
                           });
                       }];

    
}
- (IBAction)cancelCardProcess:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setupUI];
    
    
}

- (void) setupUI
{
    
    //Code based UI
    /*
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIColor *boarderColor = UIColor.lightGrayColor;
    UIColor *backgroundColor = UIColor.whiteColor;
    
    
    
    cardNumberText = UITextField.new;
    cardNumberText.backgroundColor = backgroundColor;
    cardNumberText.layer.borderColor = boarderColor.CGColor;
    cardNumberText.layer.borderWidth = 1;
    cardNumberText.placeholder = @"0000 0000 0000 0000";
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [cardNumberText addGestureRecognizer:singleTap];
    
    cardNameText = UITextField.new;
    cardNameText.backgroundColor = backgroundColor;
    cardNameText.layer.borderColor = UIColor.lightGrayColor.CGColor;
    cardNameText.layer.borderWidth = 1;
    cardNameText.placeholder = @"Name on Card";
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [cardNameText addGestureRecognizer:singleTap];
    
    cardCCVText = UITextField.new;
    cardCCVText.backgroundColor = UIColor.lightGrayColor;
    cardCCVText.layer.borderColor = UIColor.lightGrayColor.CGColor;
    cardCCVText.layer.borderWidth = 1;
    cardCCVText.placeholder = @"123";
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [cardCCVText addGestureRecognizer:singleTap];
    
    cardExpiresMonthText = UITextField.new;
    cardExpiresMonthText.backgroundColor = UIColor.lightGrayColor;
    cardExpiresMonthText.layer.borderColor = UIColor.blackColor.CGColor;
    cardExpiresMonthText.layer.borderWidth = 1;
    cardExpiresMonthText.placeholder = @"01";
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [cardExpiresMonthText addGestureRecognizer:singleTap];
    
    cardExpiresYearText = UITextField.new;
    cardExpiresYearText.backgroundColor = UIColor.lightGrayColor;
    cardExpiresYearText.layer.borderColor = UIColor.blackColor.CGColor;
    cardExpiresYearText.layer.borderWidth = 1;
    cardExpiresYearText.placeholder = @"01";
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [cardExpiresYearText addGestureRecognizer:singleTap];
    
    
    
    UIView *holderView = UIView.new;
    holderView.backgroundColor = UIColor.whiteColor;
    
    UIView *amountDueView = UIView.new;
    holderView.backgroundColor = UIColor.lightGrayColor;
    
    [self.view addSubview:holderView];
    
    //Logo
    UIImageView *logoImage =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,200,50)];
    
    NSBundle *podBundle = [NSBundle bundleForClass:self.classForCoder];
    NSURL *url = [podBundle URLForResource:@"Heartland-iOS-SDK" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    logoImage.image=[UIImage imageNamed:@"heartlandlogo" inBundle:bundle compatibleWithTraitCollection:nil];
    [holderView addSubview:logoImage];
    
    [holderView addSubview:cardNumberText];
    [holderView addSubview:cardNameText];
    [holderView addSubview:cardExpiresMonthText];
    [holderView addSubview:cardExpiresYearText];
    [holderView addSubview:cardCCVText];
     
     
    int padding = 10;
    
    [holderView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(padding + 20);
        make.left.equalTo(self.view.left).offset(padding);
        make.bottom.equalTo(self.view.bottom).offset(-padding);
        make.right.equalTo(self.view.right).offset(-padding);
        
        
        //        make.width.equalTo(self.view.width).offset(-padding * 2);
        //        make.height.equalTo(self.view.height).offset(-padding * 2);
    }];
    
    [cardNumberText makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(holderView.top).offset(padding);
        make.left.equalTo(holderView.left).offset(padding);
        make.height.equalTo(40);
        make.width.equalTo(holderView.width).offset(-padding * 2);
    }];
    
    [cardNameText makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(holderView.top).offset(padding);
        make.left.equalTo(holderView.left).offset(padding);
        make.height.equalTo(40);
        make.width.equalTo(holderView.width).offset(-padding * 2);
    }];
    
    [self.scrollView addSubview:holderView];
    
    //set bottom
        [holderView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cardExpiresYearText.bottom);
        }];
     
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
