//
//  LogInVIEW.m
//  MyWedding
//
//  Created by Mango SW on 20/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "LogInVIEW.h"
#import "MobileVerification.h"
#import "MyWedding.pch"
#import "ForgotPasswordVW.h"
@interface LogInVIEW ()

@end

@implementation LogInVIEW
@synthesize MobileTXT,PasswordTXT;
@synthesize popupTBL,PopUpView,CountryCodeBTN;

- (void)viewDidLoad
{
    PopUpView.hidden=YES;
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    

    // Do any additional setup after loading the view.
}

- (IBAction)SignIn_Action:(id)sender
{
    
    if ([MobileTXT.text isEqualToString:@""])
    {
        //[self ShowPOPUP];
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Mobile Number" delegate:nil];
    }
    else
    {
            if ([PasswordTXT.text isEqualToString:@""])
            {
                [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter password" delegate:nil];
            }
            else
            {
                BOOL internet=[AppDelegate connectedToNetwork];
                if (internet)
                    [self CallForloging];
                else
                    [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
            }
        }
}
-(void)CallForloging
{
    NSString *DEVICETOKEN = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"DEVICETOKEN"];
    
    if (!DEVICETOKEN) {
        DEVICETOKEN=@"DEVICETOKEN";
    }

    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:X_API_KEY  forKey:@"X-API-KEY"];
    [dictParams setObject:@"application/json"  forKey:@"Content-Type"];
    [dictParams setObject:@"99"  forKey:@"country_id"];
    [dictParams setObject:MobileTXT.text  forKey:@"mobile"];
    [dictParams setObject:PasswordTXT.text  forKey:@"password"];
    [dictParams setObject:DEVICETOKEN  forKey:@"device_token"];

    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@",LoginURL] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleSIGNINResponse:response];
     }];
}
- (void)handleSIGNINResponse:(NSDictionary*)response
{
    NSLog(@"Respose==%@",response);
    
    if ([[[response objectForKey:@"STATUS"]stringValue ] isEqualToString:@"200"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:response forKey:@"LoginUserDic"];
        //[self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:@"ERROR" message:[response objectForKey:@"MSG"] delegate:nil];
    }
    
}
- (IBAction)SignUp_Action:(id)sender
{
    MobileVerification *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MobileVerification"];
    [self.navigationController pushViewController:vcr animated:YES];
}

- (IBAction)ForgotPass_Action:(id)sender
{
    
    ForgotPasswordVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ForgotPasswordVW"];
    [self.navigationController pushViewController:vcr animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)CountryBTN_Click:(id)sender
{
    PopUpView.hidden=NO;
}
@end
