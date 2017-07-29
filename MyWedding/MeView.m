//
//  MeView.m
//  MyWedding
//
//  Created by kaushik on 02/04/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "MeView.h"
#import "MyWedding.pch"
@interface MeView ()

@end

@implementation MeView
@synthesize FirstName_TXT,MobileNo_TXT,MiddleName_TXT,LastName_TXT,Email_TXT,SecondName_TXT;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [currentDefaults objectForKey:@"USERDATADICT"];
    NSDictionary* userData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSDictionary *NameDic=[userData valueForKey:@"name"];
    MobileNo_TXT.enabled=NO; // User no Allow to update Mobile Number
    
    if ([NameDic valueForKey:@"first"] != (id)[NSNull null])
    {
        FirstName_TXT.text=[NameDic valueForKey:@"first"];
    }
    if ([NameDic valueForKey:@"second"] != (id)[NSNull null])
    {
        SecondName_TXT.text=[NameDic valueForKey:@"second"];
    }
    if ([NameDic valueForKey:@"middle"] != (id)[NSNull null])
    {
         MiddleName_TXT.text=[NameDic valueForKey:@"middle"];
    }
    if ([NameDic valueForKey:@"last"] != (id)[NSNull null])
    {
       LastName_TXT.text=[NameDic valueForKey:@"last"];
    }
    if ([userData valueForKey:@"mobile"] != (id)[NSNull null])
    {
       MobileNo_TXT.text=[userData valueForKey:@"mobile"];
    }
    if ([userData valueForKey:@"email"] != (id)[NSNull null])
    {
        Email_TXT.text=[userData valueForKey:@"email"];
    }
       
}
- (IBAction)update_Action:(id)sender
{
   
    if ([FirstName_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:NSLocalizedString(@"Error", @"") message:@"Please enter First Name" delegate:nil];
    }
    else if ([SecondName_TXT.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:NSLocalizedString(@"Error", @"") message:@"Please enter Second Name" delegate:nil];
    }
    else if ([MiddleName_TXT.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:NSLocalizedString(@"Error", @"") message:@"Please enter Middle Name" delegate:nil];
    }
    else if ([LastName_TXT.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:NSLocalizedString(@"Error", @"") message:@"Please enter Last Name" delegate:nil];
    }
    else if ([Email_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:NSLocalizedString(@"Error", @"") message:@"Please enter Email" delegate:nil];
    }
    else
    {
        if (![AppDelegate IsValidEmail:Email_TXT.text])
        {
            [AppDelegate showErrorMessageWithTitle:NSLocalizedString(@"Error", @"") message:@"Please enter valid email" delegate:nil];
        }
        else
        {
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
            {
                [self profileUpdate];
            }
            else
                [AppDelegate showErrorMessageWithTitle:@"" message:NSLocalizedString(@"Please check your internet", @"") delegate:nil];
        }
    }
}
-(void)profileUpdate
{
    NSString *DEVICETOKEN = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"DEVICETOKEN"];
    
    if (!DEVICETOKEN) {
        DEVICETOKEN=@"DEVICETOKEN";
    }
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [currentDefaults objectForKey:@"USERDATADICT"];
    NSDictionary* userData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString *cutmrID=[userData valueForKey:@"id"];
    NSString *newToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERTOKEN"];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:newToken  forKey:@"X-API-KEY"];
    [dictParams setObject:@"application/json"  forKey:@"Content-Type"];
    
    [dictParams setObject:cutmrID  forKey:@"customer_id"]; // Custmer ID to Replace dynamic after testing complete
    [dictParams setObject:FirstName_TXT.text  forKey:@"first_name"];
    [dictParams setObject:SecondName_TXT.text  forKey:@"second_name"];
    [dictParams setObject:MiddleName_TXT.text  forKey:@"middle_name"];
    
    [dictParams setObject:LastName_TXT.text  forKey:@"last_name"];
    [dictParams setObject:Email_TXT.text  forKey:@"email"];
    
    [dictParams setObject:DEVICETOKEN  forKey:@"device_token"];
    [dictParams setObject:@"ios"  forKey:@"device_type"];// This is a static string for Device is IOS or Android
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@",registerURL] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleUpdateProfileResponse:response];
     }];
}

- (void)handleUpdateProfileResponse:(NSDictionary*)response
{
    NSLog(@"Respose==%@",response);
    if ([[[response objectForKey:@"STATUS"]stringValue ] isEqualToString:@"200"])
    {
        NSDictionary *userdata=[response valueForKey:@"DATA"];
        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userdata];
        [currentDefaults setObject:data forKey:@"USERDATADICT"];
        [AppDelegate showErrorMessageWithTitle:@"Success" message:@"You've successfully Update!!" delegate:nil];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:NSLocalizedString(@"Error", @"") message:[response objectForKey:@"MSG"] delegate:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
