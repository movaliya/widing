//
//  ForgotPasswordVW.h
//  MyWedding
//
//  Created by Mango SW on 20/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordVW : UIViewController
{
    
}

@property (strong, nonatomic) IBOutlet UIButton *Country_BTN;
- (IBAction)CountryBTN_Click:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *MobileNumber_TXT;
@property (weak, nonatomic) IBOutlet UIButton *CodeBtn;

@property (strong, nonatomic) IBOutlet UIView *VerificatoinView;
- (IBAction)Submit_Click:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *Verification_TXT;

@property (strong, nonatomic) IBOutlet UITableView *Country_TBL;
@property (strong, nonatomic) IBOutlet UIView *CountryPopup;
@end
