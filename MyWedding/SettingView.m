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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Are you sure want to Logout?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Logout",nil];
    alert.tag=50;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // the user clicked Logout
    if (alertView.tag==50)
    {
        if (buttonIndex == 1)
        {
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
                [self LogoutService];
            else
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        }
    }
}
-(void)LogoutService
{
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [currentDefaults objectForKey:@"USERDATADICT"];
    NSDictionary* userData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString *cutmrID=[userData valueForKey:@"id"];
    
    NSString *newToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERTOKEN"];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:newToken  forKey:@"X-API-KEY"];
    [dictParams setObject:@"application/json"  forKey:@"Content-Type"];
    [dictParams setObject:cutmrID  forKey:@"customer_id"];
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@",logoutURL] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleLogoutResponse:response];
     }];
}
- (void)handleLogoutResponse:(NSDictionary*)response
{
    NSLog(@"reset Respose==%@",response);
    
    if ([[[response objectForKey:@"STATUS"]stringValue ] isEqualToString:@"200"])
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"USERDATADICT"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"USERTOKEN"];
        [self.navigationController popToRootViewControllerAnimated:NO];
       [AppDelegate showErrorMessageWithTitle:@"Success" message:[response objectForKey:@"MSG"] delegate:nil];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:@"ERROR" message:[response objectForKey:@"MSG"] delegate:nil];
    }
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
        if (![NewPass_TXT.text isEqualToString:ConfirmPass_TXT.text])
        {
             [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"New password and Confirm password is not same" delegate:nil];
        }
        else
        {
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
                 [self ResetPasswrdMethod];
            else
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
           
        }
    }
}
-(void)ResetPasswrdMethod
{
    
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [currentDefaults objectForKey:@"USERDATADICT"];
    NSDictionary* userData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString *cutmrID=[userData valueForKey:@"id"];
    
    NSString *newToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERTOKEN"];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:newToken  forKey:@"X-API-KEY"];
    [dictParams setObject:@"application/json"  forKey:@"Content-Type"];
    [dictParams setObject:cutmrID  forKey:@"customer_id"];
    [dictParams setObject:OldPass_TXT.text  forKey:@"old_password"];
    [dictParams setObject:NewPass_TXT.text  forKey:@"new_password"];
    [dictParams setObject:ConfirmPass_TXT.text  forKey:@"confirm_password"];
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@",changePasswordURL] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleRestPassResponse:response];
     }];
}

- (void)handleRestPassResponse:(NSDictionary*)response
{
    NSLog(@"reset Respose==%@",response);
    
    if ([[[response objectForKey:@"STATUS"]stringValue ] isEqualToString:@"200"])
    {
        OldPass_TXT.text=@"";
        NewPass_TXT.text=@"";
        ConfirmPass_TXT.text=@"";
        ChangePasswordView.hidden=YES;
         [AppDelegate showErrorMessageWithTitle:@"Success" message:[response objectForKey:@"MSG"] delegate:nil];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:@"ERROR" message:[response objectForKey:@"MSG"] delegate:nil];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    OldPass_TXT.text=@"";
    NewPass_TXT.text=@"";
    ConfirmPass_TXT.text=@"";
    
    ChangePasswordView.hidden=YES;
    [OldPass_TXT resignFirstResponder];
    [NewPass_TXT resignFirstResponder];
    [ConfirmPass_TXT resignFirstResponder];
}
@end
