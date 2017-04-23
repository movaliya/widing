//
//  SettingView.m
//  MyWedding
//
//  Created by Mango SW on 04/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "SettingView.h"
#import "AppDelegate.h"
#import "MyWedding.pch"

@interface SettingView ()

@end

@implementation SettingView
@synthesize ChangePasswordView,OldPass_TXT,NewPass_TXT,ConfirmPass_TXT;

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ChangePasswordView.hidden=YES;
}

- (IBAction)ChangePassword_Action:(id)sender
{
    ChangePasswordView.hidden=NO;
}

- (IBAction)ShareApp_Action:(id)sender
{
    
}

- (IBAction)SignOut_Action:(id)sender
{
    
}


- (IBAction)Back_Btn_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)Reset_Click:(id)sender
{
    
    if ([OldPass_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Old Password" delegate:nil];
    }
    else if ([NewPass_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter New Password" delegate:nil];
    }
    else if ([ConfirmPass_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Confirm Password" delegate:nil];
    }
    else
    {
        if ([NewPass_TXT.text isEqualToString:ConfirmPass_TXT.text])
        {
            
        }
        else
        {
             [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"New password and Confirm password is not same" delegate:nil];
        }
        
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ChangePasswordView.hidden=YES;
    [OldPass_TXT resignFirstResponder];
    [NewPass_TXT resignFirstResponder];
    [ConfirmPass_TXT resignFirstResponder];
}
@end
