	//
	//  HpsCardInfoViewController.m
	//  Heartland-iOS-SDK
	//
	//  Created by Heartland on 26/07/18.
	//

#import "HpsCardInfoViewController.h"
#import "HpsEnum.h"

#define AMEX  		@"^3[47][0-9]{13}$"
#define MASTERCARD  @"^5[1-5][0-9]{14}$|^(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$"
#define VISA  		@"^4[0-9]{12}(?:[0-9]{3})?$"
#define DISCOVER    @"^6(?:011|5[0-9]{2}|4[4-9][0-9])[0-9]{12}$|^6(22[2-8])[0-9]{12}$|^622126[0-9]{10}|^622925[0-9]{10}|^6(221[3-8][0-9])"
#define JCB  		@"^(352[8|9]|35[3-7][0-9]|358[0-9]|3589)[0-9]{12}$|(^(2131|1800)[0-9]{11}$)"
#define DINERSCLUB 	@"^3(?:0[0-5]|[68][0-9])[0-9]{11}$"
#define ROUTECLUB 	@"(^(2014)|^(2149))\\d{11}$"
#define GIFTCARD    @"^5022[0-9]{12}$"

#define FF_AMEX  	   	@"^3[47][0-9]{2}$"
#define FF_MASTERCARD  	@"^5[1-5][0-9]{2}$|^(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)$"
#define FF_VISA  	   	@"^4[0-9]{3}$"
#define FF_DISCOVER  	@"^6(?:011|5[0-9]{2}|4[4-9][0-9]{1}|22[1-9])$"
#define FF_JCB  		@"^(352[8|9]|35[3-7][0-9]|358[0-9]|3589)$|^(2131|1800)$"
#define FF_DINERSCLUB 	@"^3(?:0[0-5]|[6789][0-9])[0-9]{1}$"
#define FF_ROUTECLUB 	@"(^(2014)|^(2149))$"
#define FF_GIFT         @"^5022$"

#define PODBUNDLE 	[NSBundle bundleForClass:self.classForCoder]
#define PODURL 		[PODBUNDLE URLForResource:nil withExtension:@"bundle"]
#define BUNDLE 		[NSBundle bundleWithURL:PODURL]

#define CARD_CHARACTERS  @"0123456789-"
#define NAME_CHARACTERS  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "

@interface HpsCardInfoViewController () {

	NSDateComponents *currentDateComponents;
	UIPickerView *myPickerView;
}

@property (nonatomic,strong) UIScrollView *cardEntryScrollView;
@property (nonatomic,strong) UITextField *cardNumberText;
@property (nonatomic,strong) UITextField *cardNameText;
@property (nonatomic,strong) UITextField *cardCVVText;
@property (nonatomic,strong) UITextField *cardExpiryText;

@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *numberLbl;
@property (nonatomic,strong) UILabel *expiryLbl;
@property (nonatomic,strong) UILabel *cvvLbl;
@property (nonatomic,strong) UIButton *btnSubmit;
@property (nonatomic,strong) UIImageView *cardsImgView;
@property (nonatomic,strong) UIImageView *cardTypeImgView;
@property (nonatomic,strong) UIImageView *cvvImgView;

@property (nonatomic,strong) NSMutableArray *yearsArray;
@property (nonatomic,strong) NSMutableArray *monthsArray;
@property (nonatomic,strong) NSMutableDictionary *dictCards;
@property (nonatomic,strong) NSMutableDictionary *dictRegex;
@property (assign) TypeOfCard cardType;

@end

@implementation HpsCardInfoViewController

@synthesize cardEntryScrollView,cardNumberText,cardNameText,cardCVVText,cardExpiryText,nameLbl,numberLbl,expiryLbl,cvvLbl,btnSubmit,yearsArray,monthsArray,cardsImgView,cardTypeImgView,cvvImgView,apiKey;

- (void)viewDidLoad {

	[super viewDidLoad];
		// Do any additional setup after loading the view.

	self.navigationController.navigationBar.hidden = NO;

	self.dictCards = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
					 VISA,@"1",
					 MASTERCARD,@"2",
					 AMEX,@"3",
					 DISCOVER,@"4",
					 JCB,@"5",
					 GIFTCARD,@"6",
					 nil];

	self.dictRegex = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
					  FF_AMEX,@"Amex",
					  FF_MASTERCARD,@"MC",
					  FF_VISA,@"Visa",
					  FF_DISCOVER,@"Discover",
					  FF_JCB,@"Jcb",
					  FF_GIFT,@"Gift",
					  nil];

	UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Back"
								   style:UIBarButtonItemStylePlain
								   target:self
								   action:@selector(goBack)];

	self.navigationItem.backBarButtonItem = backButton;

	[self setUpCustomPicker];
	[self setupUI];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
		// Dispose of any resources that can be recreated.
}

#pragma mark - SetUp UI
- (void) setupUI
{
		//Code based UI
	cardEntryScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	cardEntryScrollView.backgroundColor = [UIColor whiteColor];
	cardEntryScrollView.showsVerticalScrollIndicator = NO;
	cardEntryScrollView.showsHorizontalScrollIndicator = NO;

	CGFloat width = self.cardEntryScrollView.frame.size.width;

		//Logo
	cardsImgView = [[UIImageView alloc] initWithFrame:CGRectMake((width-220)/2,0,220,60)];
	cardsImgView.image = [UIImage imageNamed:@"icon_cards" inBundle:BUNDLE compatibleWithTraitCollection:nil];
	cardsImgView.contentMode = UIViewContentModeScaleAspectFit;
	[self.cardEntryScrollView addSubview:cardsImgView];

	nameLbl = [self getLabel:CGRectMake(15, cardsImgView.frame.origin.y+50, width-30, 25) title:@"Card Holder Name"];
	[cardEntryScrollView addSubview:nameLbl];

	cardNameText = [self getTextField:CGRectMake(15, (nameLbl.frame.origin.y+25+5), (self.view.frame.size.width-30), 40) placeholder:@"Card Holder Name" tag:1];
	cardNameText.keyboardType = UIKeyboardTypeAlphabet;
	cardNameText.autocapitalizationType = UITextAutocapitalizationTypeWords;
	cardNameText.autocorrectionType = UITextAutocorrectionTypeNo;
	[cardEntryScrollView addSubview:cardNameText];

	numberLbl = [self getLabel:CGRectMake(15, cardNameText.frame.origin.y+50, width-30, 25) title:@"Card Number"];
	[cardEntryScrollView addSubview:numberLbl];

	cardNumberText = [self getTextField:CGRectMake(15, (numberLbl.frame.origin.y+25+5), (self.view.frame.size.width-30), 40) placeholder:@"Card Number" tag:2];
	cardNumberText.keyboardType = UIKeyboardTypeNumberPad;
	[cardEntryScrollView addSubview:cardNumberText];

	cardTypeImgView = [[UIImageView alloc] initWithFrame:CGRectMake((cardEntryScrollView.frame.size.width-15-45), (cardNumberText.frame.origin.y+5), 40, 30)];
	cardTypeImgView.image = [UIImage imageNamed:@"icon_card_empty" inBundle:BUNDLE compatibleWithTraitCollection:nil];
	cardTypeImgView.contentMode = UIViewContentModeScaleAspectFit;
	[self.cardEntryScrollView addSubview:cardTypeImgView];

	expiryLbl = [self getLabel:CGRectMake(15, cardNumberText.frame.origin.y+40+10, width-30, 25) title:@"Card Expiration"];
	[cardEntryScrollView addSubview:expiryLbl];

	cardExpiryText = [self getTextField:CGRectMake(15, (expiryLbl.frame.origin.y+25+5), (self.view.frame.size.width-30), 40) placeholder:@"MM / YYYY" tag:3];
	cardExpiryText.inputView = myPickerView;
	[cardEntryScrollView addSubview:cardExpiryText];

	cvvLbl = [self getLabel:CGRectMake(15, cardExpiryText.frame.origin.y+40+10, width-30, 25) title:@"Card CVV"];
	[cardEntryScrollView addSubview:cvvLbl];

	cardCVVText = [self getTextField:CGRectMake(15, (cvvLbl.frame.origin.y+25+5), (self.view.frame.size.width-30), 40) placeholder:@"Card CVV" tag:4];
	cardCVVText.keyboardType = UIKeyboardTypeNumberPad;
	cardCVVText.secureTextEntry = YES;
	[cardEntryScrollView addSubview:cardCVVText];

	cvvImgView = [[UIImageView alloc] initWithFrame:CGRectMake((cardEntryScrollView.frame.size.width-15-45), (cardCVVText.frame.origin.y+5), 40, 30)];
	cvvImgView.image = [UIImage imageNamed:@"icon_cvv" inBundle:BUNDLE compatibleWithTraitCollection:nil];
	cvvImgView.contentMode = UIViewContentModeScaleAspectFit;
	[self.cardEntryScrollView addSubview:cvvImgView];

	btnSubmit = [UIButton buttonWithType:UIButtonTypeSystem];
	btnSubmit.frame = CGRectMake((width-160)/2, cardCVVText.frame.origin.y+40+20, 160, 50);
	[btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];
	[btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[[btnSubmit titleLabel] setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18.0]];
	[btnSubmit setBackgroundColor:[UIColor colorWithRed:54.0/255.0 green:180.0/255.0 blue:110.0/255.0 alpha:1.0]];
	[btnSubmit addTarget:self action:@selector(submitCardDetails) forControlEvents:UIControlEventTouchUpInside];
	[cardEntryScrollView addSubview:btnSubmit];

	[self.view addSubview:cardEntryScrollView];

	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeypad)];
	tap.numberOfTapsRequired = 1;
	[self.cardEntryScrollView addGestureRecognizer:tap];

}

#pragma mark - SetUp Custom Picker
-(void)setUpCustomPicker {

	currentDateComponents = [[NSCalendar currentCalendar] components: NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];

	monthsArray = [[NSMutableArray alloc]initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",nil];

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy"];
	NSString *yearString = [formatter stringFromDate:[NSDate date]];

	yearsArray = [[NSMutableArray alloc]init];

	for (int i=0; i<25; i++) {
		[yearsArray addObject:[NSString stringWithFormat:@"%d",[yearString intValue]+i]];
	}

	myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-200, 320, 200)];
	myPickerView.delegate = self;
	myPickerView.dataSource = self;
	myPickerView.showsSelectionIndicator = YES;
	[myPickerView selectRow:[currentDateComponents month]-1 inComponent:0 animated:YES];

}

#pragma mark - TextField Delegate
-(void)textFieldDidEndEditing:(UITextField *)textField {

	if (textField.tag == 2 && textField.text != nil) {

		NSString *type = [self validateCardType:textField.text];

		NSLog(@"card type:%@",type);
	}
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

	if (textField.tag == 1) {
			//Name TextField
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NAME_CHARACTERS] invertedSet];

		NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];

		return [string isEqualToString:filtered];
	}

	if (textField.tag == 2) {
		//Card TextField

		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:CARD_CHARACTERS] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
		if([string isEqualToString:filtered]) {

			NSInteger length = textField.text.length + string.length - range.length;

			if (length < 4) {
				cardTypeImgView.image = [UIImage imageNamed:@"icon_card_empty" inBundle:BUNDLE compatibleWithTraitCollection:nil];
				self.cardType = 0;
			}

			if ([string isEqualToString:@""]) {
				return YES;
			}

			NSString *strCard = [textField.text stringByReplacingCharactersInRange:range withString:string];

			if (length == 4) {

				self.cardType = [self findCardType:strCard];
			}

			if (self.cardType == Visa) {

				if (textField.text.length <= 22) {
					[self cardTextFormatting:textField text:strCard format:0];
					return YES;
				}else {
					return NO;
				}

			} else if (self.cardType == Amex) {

				if (textField.text.length <= 16) {
					[self cardTextFormatting:textField text:strCard format:1];
					return YES;
				}else {
					return NO;
				}

			}else if (self.cardType == Jcb) {

				if ([[strCard substringToIndex:4] isEqualToString:@"1800"] || [[strCard substringToIndex:4] isEqualToString:@"2131"]) {

					if (textField.text.length <= 16) {
						[self cardTextFormatting:textField text:strCard format:1];
						return YES;
					}else {
						return NO;
					}

				}else {
					if (textField.text.length <= 18) {
						[self cardTextFormatting:textField text:strCard format:0];
						return YES;
					}else {
						return NO;
					}
				}

			}else if (self.cardType == MasterCard || self.cardType == Discover || self.cardType == GiftCard){

				if (textField.text.length <= 18) {
					[self cardTextFormatting:textField text:strCard format:0];
					return YES;
				}else {
					return NO;
				}
			}
		}else {
			return NO;
		}
	}

	if (textField.tag == 4) {

		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:CARD_CHARACTERS] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
		if ([string isEqualToString:filtered]) {
			if (textField.text.length <= 2 || [string isEqualToString:@""]) {
				return YES;
			}else {
				return NO;
			}
		}else {
			return NO;
		}
	}

	return YES;
}

#pragma mark - Picker View Delegates
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	NSInteger rowsInComponent;

	if (component==0) {
		rowsInComponent=[monthsArray count];
	}
	else {
		rowsInComponent=[yearsArray count];
	}

	return rowsInComponent;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

	if (component == 0) {
		return [monthsArray objectAtIndex:row];
	}else {
		return [yearsArray objectAtIndex:row];
	}
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

	if ([pickerView selectedRowInComponent:0]+1 < [currentDateComponents month] && ([[yearsArray objectAtIndex:[pickerView selectedRowInComponent:1]] intValue]==[currentDateComponents year])) {

		[pickerView selectRow:([currentDateComponents month]-1) inComponent:0 animated:YES];
	}

	NSString *strExpiry = [NSString stringWithFormat:@"%@/%@",[monthsArray objectAtIndex:[pickerView selectedRowInComponent:0]],[yearsArray objectAtIndex:[pickerView selectedRowInComponent:1]]];

	cardExpiryText.text = strExpiry;

}

#pragma mark - Submit Button Action
-(void)submitCardDetails {

	[self closeKeypad];

	if ([self validateInput]) {

		NSArray *arrExpiry = [cardExpiryText.text componentsSeparatedByString:@"/"];

		HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:apiKey];

		NSString *strCard = [[cardNumberText.text stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];

		[service getTokenWithCardNumber:strCard
									cvc:cardCVVText.text
							   expMonth:[arrExpiry firstObject]
								expYear:[arrExpiry lastObject]
					   andResponseBlock:^(HpsTokenData *response) {

						   NSLog(@"response: %@", [response description]);
						   [self.delegate didReceiveToken:response];
						   [self goBack];


		}];
	}
}

#pragma mark - Find Card Type
-(int)findCardType:(NSString *)text {

	NSInteger startingDigit = 0;

	NSString *type = [self validateCardType:text];

	startingDigit = [[text substringFromIndex:0] integerValue];

	if ([type isEqualToString:@"Visa"]) {
		//VISA 4-4-4-4
		cardTypeImgView.image = [UIImage imageNamed:@"icon_visa" inBundle:BUNDLE compatibleWithTraitCollection:nil];
		return 1;
	}
	if ([type isEqualToString:@"MC"]) {
		//MASTER CARD 4-4-4-4
		cardTypeImgView.image = [UIImage imageNamed:@"icon_mastercard" inBundle:BUNDLE compatibleWithTraitCollection:nil];
		return 2;
	}
	if ([type isEqualToString:@"Amex"]) {
		//AMEX 4-6-5
		cardTypeImgView.image = [UIImage imageNamed:@"icon_amex" inBundle:BUNDLE compatibleWithTraitCollection:nil];
		return 3;
	}
	if ([type isEqualToString:@"Discover"]) {
		//DISCOVER 4-4-4-4
		cardTypeImgView.image = [UIImage imageNamed:@"icon_discover" inBundle:BUNDLE compatibleWithTraitCollection:nil];
		return 4;
	}
	if ([type isEqualToString:@"Jcb"]) {
		//JCB 4-4-4-4
		cardTypeImgView.image = [UIImage imageNamed:@"icon_jcb" inBundle:BUNDLE compatibleWithTraitCollection:nil];
		return 5;
	}
	if (startingDigit == 5022) {
		//Gift Card 4-4-4-4
		return 6;
	}

	return 0;

}

#pragma mark - Card Formatting
-(void)cardTextFormatting:(UITextField *)textField text:(NSString *)text format:(NSInteger)formatType {

	if (formatType == 0) {
		if (text.length == 5) {
			textField.text = [NSString stringWithFormat:@"%@-%@",[textField.text substringToIndex:4], [textField.text substringFromIndex:4]];
		}else if (text.length == 10){
			textField.text = [NSString stringWithFormat:@"%@-%@",[textField.text substringToIndex:9], [textField.text substringFromIndex:9]];
		}else if (text.length == 15) {
			textField.text = [NSString stringWithFormat:@"%@-%@",[textField.text substringToIndex:14], [textField.text substringFromIndex:14]];
		}else if (text.length == 20) {
			textField.text = [NSString stringWithFormat:@"%@-%@",[textField.text substringToIndex:19], [textField.text substringFromIndex:19]];
		}

	}else {
		if (text.length == 5) {
			textField.text = [NSString stringWithFormat:@"%@-%@",[textField.text substringToIndex:4], [textField.text substringFromIndex:4]];
		}else if (text.length == 12){
			textField.text = [NSString stringWithFormat:@"%@-%@",[textField.text substringToIndex:11], [textField.text substringFromIndex:11]];
		}
	}
}

#pragma mark - Validation
-(BOOL)validateInput {

	BOOL value = YES;

	if ([cardNameText.text isEqualToString:@""]) {
		[cardNameText setValue:[UIColor redColor]
						forKeyPath:@"_placeholderLabel.textColor"];
		value = NO;
	}

	if ([cardNumberText.text isEqualToString:@""]) {
		[cardNumberText setValue:[UIColor redColor]
					forKeyPath:@"_placeholderLabel.textColor"];
		value = NO;
	}

	if ([cardExpiryText.text isEqualToString:@""]) {
		[cardExpiryText setValue:[UIColor redColor]
					forKeyPath:@"_placeholderLabel.textColor"];
		value = NO;
	}

	if ([cardCVVText.text isEqualToString:@""]) {
		[cardCVVText setValue:[UIColor redColor]
					forKeyPath:@"_placeholderLabel.textColor"];
		value = NO;
	}
	if (cardNumberText.text.length > 0) {
		NSString *strCard = [[cardNumberText.text stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
		if (strCard.length != 15 && strCard.length != 16 && strCard.length != 19) {
			value = NO;
            [self showAlert:@"Invalid card number" withMessage:@"Please enter a valid card number."];
		}
	}
	if (apiKey == nil || [apiKey isEqualToString:@""]) {
		value = NO;
        [self showAlert:@"Invalid ApiKey" withMessage:@"Please assign a valid apiKey."];
	}

	return value;

}

-(void) showAlert:(NSString*)title withMessage:(NSString*)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Validate Card Types
-(NSString *)validateCardType:(NSString *)card {

	NSString *strValue = @"";
	NSString *strCard = [[card stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];

	if (card.length > 4) {

		for (NSString *key in self.dictCards.allKeys) {
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",[self.dictCards objectForKey:key]];

			if ([predicate evaluateWithObject:strCard]) {
				strValue = key;
				NSLog(@"strValue=%@",strValue);
				break;
			}
		}

	}else {

		for (NSString *key in self.dictRegex.allKeys) {
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",[self.dictRegex objectForKey:key]];

			if ([predicate evaluateWithObject:strCard]) {
				strValue = key;
				NSLog(@"strValue=%@",strValue);
				break;
			}
		}
	}

	return strValue;
}

#pragma mark - Get TextField
-(UITextField *)getTextField:(CGRect)frame placeholder:(NSString *)placeholder tag:(NSInteger)tag {

	UITextField *textFeild = [[UITextField alloc] initWithFrame:frame];
	textFeild.delegate = self;
	textFeild.tag = tag;
	textFeild.placeholder = placeholder;
	textFeild.textColor = [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0];
	textFeild.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
	textFeild.textAlignment = NSTextAlignmentLeft;
	textFeild.font = [UIFont fontWithName:@"ArialMT" size:15.0];
	textFeild.backgroundColor = [UIColor whiteColor];
	textFeild.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
	textFeild.layer.borderWidth = 1;
	textFeild.leftView = [self leftView];
	textFeild.leftViewMode = UITextFieldViewModeAlways;

	return textFeild;
}

#pragma mark - Get Label
-(UILabel *)getLabel:(CGRect)frame title:(NSString *)title {

	UILabel *lbl = [[UILabel alloc] initWithFrame:frame];
	lbl.text = title;
	lbl.textColor = [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0];
	lbl.textAlignment = NSTextAlignmentLeft;
	lbl.font = [UIFont fontWithName:@"Arial-BoldMT" size:17.0];

	return lbl;

}

#pragma mark - Left Text View
-(UIView *)leftView {
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
	view.backgroundColor = [UIColor clearColor];
	return view;
}

#pragma mark - Dismiss Keypad
-(void)closeKeypad {
	[self.view endEditing:YES];
}

#pragma mark - Dismiss View Controller
-(void)goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
