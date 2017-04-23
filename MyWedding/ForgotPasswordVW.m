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
{
    NSMutableDictionary *CountryCodeDATA;
    NSString *CountryCodeId,*UserIDStr;;
}
@end

@implementation ForgotPasswordVW
@synthesize MobileNumber_TXT,Verification_TXT,VerificatoinView;
@synthesize Country_TBL,CountryPopup,Country_BTN;

- (void)viewDidLoad
{
    [super viewDidLoad];

    VerificatoinView.hidden=YES;
    CountryPopup.hidden=YES;
    
    [self getCoutryCode];
    
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
        NSString *country = [countryLocale displayNameForKey:NSLocaleCountryCode value:countryCode];
        //****************************************************************************
        CountryCodeDATA=[response valueForKey:@"DATA"];
        
        NSArray *arrayWithCountryname = [CountryCodeDATA valueForKey:@"name"];
        NSUInteger index = [arrayWithCountryname indexOfObject:country];
        
        // NSLog(@"index=%lu",(unsigned long)index);
        // NSLog(@"code=%@",[[CountryCodeDATA valueForKey:@"code"] objectAtIndex:index]);
        
        [Country_BTN setTitle:[[CountryCodeDATA valueForKey:@"code"] objectAtIndex:index] forState:UIControlStateNormal];
        CountryCodeId=[[CountryCodeDATA valueForKey:@"id"] objectAtIndex:index];
        
        [Country_TBL reloadData];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:@"ERROR" message:[response objectForKey:@"MSG"] delegate:nil];
    }
    
}


- (IBAction)Verified_Action:(id)sender
{
    [MobileNumber_TXT resignFirstResponder];
    
    if ([MobileNumber_TXT.text isEqualToString:@""])
    {        
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
    [dictParams setObject:CountryCodeId  forKey:@"country_id"];
    [dictParams setObject:MobileNumber_TXT.text  forKey:@"mobile"];
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@",ForgotPasswordURL] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleForgotPassResponse:response];
     }];
}

- (void)handleForgotPassResponse:(NSDictionary*)response
{
    NSLog(@"Respose==%@",response);
    
    if ([[[response objectForKey:@"STATUS"]stringValue ] isEqualToString:@"200"])
    {
        UserIDStr=[NSString stringWithFormat:@"%@",[[response valueForKey:@"DATA"] valueForKey:@"id"]];
        VerificatoinView.hidden=NO;
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:@"ERROR" message:[response objectForKey:@"MSG"] delegate:nil];
    }
}

- (IBAction)CountryCode_Action:(id)sender
{
}

- (IBAction)BackBtn_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Submit_Click:(id)sender
{
    [Verification_TXT resignFirstResponder];
    VerificatoinView.hidden=YES;
}
- (IBAction)CountryBTN_Click:(id)sender
{
    CountryPopup.hidden=NO;
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
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    cell.textLabel.text = [[CountryCodeDATA valueForKey:@"name"] objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [Country_BTN setTitle:[[CountryCodeDATA valueForKey:@"code"] objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    CountryCodeId=[[CountryCodeDATA valueForKey:@"id"] objectAtIndex:indexPath.row];
    CountryPopup.hidden=YES;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CountryPopup.hidden=YES;
    VerificatoinView.hidden=YES;
    [MobileNumber_TXT resignFirstResponder];
    [Verification_TXT resignFirstResponder];
}


@end
