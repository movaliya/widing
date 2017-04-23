//
//  SettingView.h
//  MyWedding
//
//  Created by Mango SW on 04/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingView : UIViewController
{
    
}
@property (strong, nonatomic) IBOutlet UIView *ChangePasswordView;
@property (strong, nonatomic) IBOutlet UITextField *OldPass_TXT;
@property (strong, nonatomic) IBOutlet UITextField *NewPass_TXT;
@property (strong, nonatomic) IBOutlet UITextField *ConfirmPass_TXT;
- (IBAction)Reset_Click:(id)sender;

@end
