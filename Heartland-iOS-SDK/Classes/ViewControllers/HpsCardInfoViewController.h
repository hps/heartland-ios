//
//  HpsCardInfoViewController.h
//  Heartland-iOS-SDK
//
//  Created by Heartland on 26/07/18.
//

#import <UIKit/UIKit.h>
#import "HpsTokenService.h"
#import "HpsTokenData.h"

@protocol ITokenDelegate
@required
-(void)didReceiveToken:(HpsTokenData *)tokenData;
@end

@interface HpsCardInfoViewController : UIViewController<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic,strong) NSString *apiKey;
@property (nonatomic,weak) id<ITokenDelegate> delegate;

@end
