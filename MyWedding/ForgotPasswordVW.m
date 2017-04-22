//
//  ForgotPasswordVW.m
//  MyWedding
//
//  Created by Mango SW on 20/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "ForgotPasswordVW.h"
#import "MyWedding.pch"
@interface ForgotPasswordVW ()

@end

@implementation ForgotPasswordVW
@synthesize MobileNumber_TXT;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)Verified_Action:(id)sender
{
    if ([MobileNumber_TXT.text isEqualToString:@""])
    {
        //[self ShowPOPUP];
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Mobile Number" delegate:nil];
    }
    else
    {
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
            [self CallForgotPass];
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    }
}
-(void)CallForgotPass
{
   
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:X_API_KEY  forKey:@"X-API-KEY"];
    [dictParams setObject:@"application/json"  forKey:@"Content-Type"];
    [dictParams setObject:@"99"  forKey:@"country_id"];
    [dictParams setObject:MobileNumber_TXT.text  forKey:@"mobile"];
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@",ForgotPasswordURL] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
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
- (IBAction)BackBtn_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

@end
