//
//  LogInVIEW.h
//  MyWedding
//
//  Created by Mango SW on 20/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInVIEW : UIViewController
{
    NSMutableDictionary *CountryCodeDATA;
    NSString *CountryCodeId;
}
@property (weak, nonatomic) IBOutlet UITextField *MobileTXT;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTXT;
@property (strong, nonatomic) IBOutlet UIButton *CountryCodeBTN;
- (IBAction)CountryBTN_Click:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *PopUpView;
@property (strong, nonatomic) IBOutlet UITableView *popupTBL;
@end
