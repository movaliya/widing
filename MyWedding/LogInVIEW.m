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
#import "MBXFreeButtonsViewController.h"
@interface LogInVIEW ()

@end

@implementation LogInVIEW
@synthesize MobileTXT,PasswordTXT;
@synthesize popupTBL,PopUpView,CountryCodeBTN,dontHave_LBL;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dontHave_LBL.text = NSLocalizedString(@"Don't have an account? Sign up", @"");
    
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        NSString *Token=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERTOKEN"];
        
        PopUpView.hidden=YES;
        
        if (Token)
        {
            MBXFreeButtonsViewController *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MBXFreeButtonsViewController"];
            [self.navigationController pushViewController:vcr animated:YES];
        }
        else
        {
            [self performSelector:@selector(getCoutryCode) withObject:nil afterDelay:2.0];
        }
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:@"" message:NSLocalizedString(@"Please check your internet", @"") delegate:nil];
    }
    

   
    // Do any additional setup after loading the view.
}

- (IBAction)SignIn_Action:(id)sender
{
    
    if ([MobileTXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Please enter Mobile Number", @"") delegate:nil];
    }
   else if (CountryCodeBTN.titleLabel.text.length == 0)
   {
        [AppDelegate showErrorMessageWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Please Select Country Code", @"") delegate:nil];
    }
   else if (CountryCodeId.length == 0)
   {
       [AppDelegate showErrorMessageWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Server down please try after some time", @"") delegate:nil];
   }
    else
    {
            if ([PasswordTXT.text isEqualToString:@""])
            {
                [AppDelegate showErrorMessageWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Please enter password",@"") delegate:nil];
            }
            else
            {
                BOOL internet=[AppDelegate connectedToNetwork];
                if (internet)
                    [self CallForloging];
                else
                    [AppDelegate showErrorMessageWithTitle:@"" message:NSLocalizedString(@"Please check your internet", @"") delegate:nil];
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
    //[dictParams setObject:X_API_KEY  forKey:@"X-API-KEY"];
    //[dictParams setObject:@"application/json"  forKey:@"Content-Type"];
    [dictParams setObject:CountryCodeId  forKey:@"country_id"];
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
    if ([[[response objectForKey:@"STATUS"]stringValue ] isEqualToString:@"200"])
    {
        [self GenrateNewToken];
        [AppDelegate showErrorMessageWithTitle:NSLocalizedString(@"Success",@"") message:[response objectForKey:@"MSG"] delegate:nil];
        NSDictionary *userdata=[response valueForKey:@"DATA"];
        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userdata];
        [currentDefaults setObject:data forKey:@"USERDATADICT"];
        MobileTXT.text=@"";
        PasswordTXT.text=@"";
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:NSLocalizedString(@"Error", @"") message:[response objectForKey:@"MSG"] delegate:nil];
    }
    
}
#pragma mark- Gerate New TOKEN After Login
-(void)GenrateNewToken
{
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@",GenrateNewTokenURL] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleUserTokenResponse:response];
     }];
}
- (void)handleUserTokenResponse:(NSDictionary*)response
{
    NSLog(@"USER KEY Respose==%@",response);
    
    if ([[[response objectForKey:@"STATUS"]stringValue ] isEqualToString:@"200"])
    {
        NSString *key=[response objectForKey:@"KEY"];
        [[NSUserDefaults standardUserDefaults] setObject:key forKey:@"USERTOKEN"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        MBXFreeButtonsViewController *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MBXFreeButtonsViewController"];
        [self.navigationController pushViewController:vcr animated:YES];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:NSLocalizedString(@"Error", @"") message:[response objectForKey:@"MSG"] delegate:nil];
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
-(void)getCoutryCode
{
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:X_API_KEY  forKey:@"X-API-KEY"];
    [dictParams setObject:@"application/json"  forKey:@"Content-Type"];
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@",GetCountryCodeURL] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleCountryCodeResponse:response];
     }];
    
}
- (void)handleCountryCodeResponse:(NSDictionary*)response
{
    NSLog(@"Respose==%@",response);
    
    if ([[[response objectForKey:@"STATUS"]stringValue ] isEqualToString:@"200"])
    {
        //***************************Local Device country Code Take******************
        NSLocale *countryLocale = [NSLocale currentLocale];
        NSString *countryCode = [countryLocale objectForKey:NSLocaleCountryCode];
       // NSString *country = [countryLocale displayNameForKey:NSLocaleCountryCode value:countryCode];
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        NSString *country = [usLocale displayNameForKey: NSLocaleCountryCode value: countryCode];
        
        //****************************************************************************
        CountryCodeDATA=[response valueForKey:@"DATA"];
        
        NSArray *arrayWithCountryname = [CountryCodeDATA valueForKey:@"name"];
        NSUInteger index = [arrayWithCountryname indexOfObject:country];
        
       // NSLog(@"index=%lu",(unsigned long)index);
       // NSLog(@"code=%@",[[CountryCodeDATA valueForKey:@"code"] objectAtIndex:index]);
        
        [CountryCodeBTN setTitle:[[CountryCodeDATA valueForKey:@"code"] objectAtIndex:index] forState:UIControlStateNormal];
        CountryCodeId=[NSString stringWithFormat:@"%@",[[CountryCodeDATA valueForKey:@"id"] objectAtIndex:index]];
        
        [popupTBL reloadData];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:NSLocalizedString(@"Error", @"") message:[response objectForKey:@"MSG"] delegate:nil];
    }
    
}
#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CountryCodeDATA.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[CountryCodeDATA valueForKey:@"name"] objectAtIndex:indexPath.row];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.backgroundColor=[UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [CountryCodeBTN setTitle:[[CountryCodeDATA valueForKey:@"code"] objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    CountryCodeId=[NSString stringWithFormat:@"%@",[[CountryCodeDATA valueForKey:@"id"] objectAtIndex:indexPath.row]];
   PopUpView.hidden=YES;
}

- (IBAction)CountryBTN_Click:(id)sender
{
    PopUpView.hidden=NO;
    [MobileTXT resignFirstResponder];
    [PasswordTXT resignFirstResponder];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
     PopUpView.hidden=YES;
    [MobileTXT resignFirstResponder];
    [PasswordTXT resignFirstResponder];
}
@end
