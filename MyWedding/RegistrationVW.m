//
//  RegistrationVW.m
//  MyWedding
//
//  Created by Mango SW on 20/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "RegistrationVW.h"
#import "MyWedding.pch"
@interface RegistrationVW ()

@end

@implementation RegistrationVW
@synthesize FirstNameTXT,SecondNameTXT,MiddleNameTXT,LastNameTXT,PasswordTXT,EmailTXT,VillNoTXT,AreaTXT,StreetNameTXT,DateOfYearTXT,ZoneTXT;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)SignUp_Action:(id)sender
{
    if ([FirstNameTXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter First Name" delegate:nil];
    }
    else if ([SecondNameTXT.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Second Name" delegate:nil];
    }
    else if ([MiddleNameTXT.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Middle Name" delegate:nil];
    }
    else if ([LastNameTXT.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Last Name" delegate:nil];
    }
    else if ([PasswordTXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter password" delegate:nil];
    }
    else if ([EmailTXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Email" delegate:nil];
    }
    else if ([VillNoTXT.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Vill NO" delegate:nil];
    }
    else if ([AreaTXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Area" delegate:nil];
    }
    else if ([StreetNameTXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Street Name" delegate:nil];
    }
    else if ([DateOfYearTXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Date Of Year" delegate:nil];
    }
    else if ([ZoneTXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Zone" delegate:nil];
    }
    
    else
    {
        if (![AppDelegate IsValidEmail:EmailTXT.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter valid email" delegate:nil];
        }
        else
        {
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
            {
                [self CallSignup];
            }
            else
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
            
        }
    }
}

-(void)CallSignup
{
    NSString *DEVICETOKEN = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"DEVICETOKEN"];
    
    if (!DEVICETOKEN) {
        DEVICETOKEN=@"DEVICETOKEN";
    }
        
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:X_API_KEY  forKey:@"X-API-KEY"];
    [dictParams setObject:@"application/json"  forKey:@"Content-Type"];
    
    [dictParams setObject:@"102"  forKey:@"customer_id"];
    [dictParams setObject:FirstNameTXT.text  forKey:@"first_name"];
    [dictParams setObject:SecondNameTXT.text  forKey:@"second_name"];
    [dictParams setObject:MiddleNameTXT.text  forKey:@"middle_name"];
    
    [dictParams setObject:LastNameTXT.text  forKey:@"last_name"];
    [dictParams setObject:PasswordTXT.text  forKey:@"password"];
    [dictParams setObject:DateOfYearTXT.text  forKey:@"date_of_year"];
    [dictParams setObject:EmailTXT.text  forKey:@"email"];
    
    [dictParams setObject:DEVICETOKEN  forKey:@"device_token"];
    [dictParams setObject:@"ios"  forKey:@"device_type"];
    [dictParams setObject:VillNoTXT.text  forKey:@"villa_no"];
    [dictParams setObject:StreetNameTXT.text  forKey:@"street_name"];
    [dictParams setObject:AreaTXT.text  forKey:@"area"];
    [dictParams setObject:ZoneTXT.text  forKey:@"zone"];
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@",registerURL] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleRegisterResponse:response];
     }];
}
- (void)handleRegisterResponse:(NSDictionary*)response
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
- (IBAction)BackBtn_action:(id)sender
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
