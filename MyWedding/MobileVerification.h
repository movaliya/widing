//
//  MobileVerification.h
//  MyWedding
//
//  Created by Mango SW on 20/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MobileVerification : UIViewController
{
    NSMutableDictionary *CountryCodeDATA;
    NSString *CountryCodeId;
    NSString *customerId;
}
@property (weak, nonatomic) IBOutlet UITextField *mobile_TXT;
@property (strong, nonatomic) IBOutlet UIView *PopupView;
@property (strong, nonatomic) IBOutlet UITableView *PopupTBL;
- (IBAction)Register_Click:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *Country_BTN;
- (IBAction)CountryBTN_Click:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *VerificationPOPupView;
- (IBAction)Verified_Click:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *VerificatonTXT;

@end
