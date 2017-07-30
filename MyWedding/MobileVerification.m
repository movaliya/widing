//
//  MobileVerification.m
//  MyWedding
//
//  Created by Mango SW on 20/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "MobileVerification.h"
#import "MyWedding.pch"
#import "RegistrationVW.h"

@interface MobileVerification ()
{
    
}
@end

@implementation MobileVerification
@synthesize Country_BTN,PopupTBL,PopupView,VerificationPOPupView,VerificatonTXT;

- (void)viewDidLoad
{
    [super viewDidLoad];
    PopupView.hidden=YES;
    VerificationPOPupView.hidden=YES;
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
         [self performSelector:@selector(getCoutryCode) withObject:nil afterDelay:0.0];
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:NSLocalizedString(@"Please check your internet", @"") delegate:nil];
   
    // Do any additional setup after loading the view.
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
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];

        NSString *country = [usLocale displayNameForKey:NSLocaleCountryCode value:countryCode];
        //****************************************************************************
        CountryCodeDATA=[response valueForKey:@"DATA"];
        
        NSArray *arrayWithCountryname = [CountryCodeDATA valueForKey:@"name"];
        NSUInteger index = [arrayWithCountryname indexOfObject:country];
        
        // NSLog(@"index=%lu",(unsigned long)index);
        // NSLog(@"code=%@",[[CountryCodeDATA valueForKey:@"code"] objectAtIndex:index]);
        
        [Country_BTN setTitle:[[CountryCodeDATA valueForKey:@"code"] objectAtIndex:index] forState:UIControlStateNormal];
        CountryCodeId=[NSString stringWithFormat:@"%@",[[CountryCodeDATA valueForKey:@"id"] objectAtIndex:index]];
        
        [PopupTBL reloadData];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:NSLocalizedString(@"Error", @"") message:[response objectForKey:@"MSG"] delegate:nil];
    }
    
}

#pragma mark - Register Mobile
- (IBAction)Register_Click:(id)sender
{
     [self.mobile_TXT resignFirstResponder];
    if ([self.mobile_TXT.text isEqualToString:@""])
    {
        //[self ShowPOPUP];
        
        [AppDelegate showErrorMessageWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Please enter Mobile Number",@"") delegate:nil];
    }
    else if (Country_BTN.titleLabel.text.length == 0)
    {
        [AppDelegate showErrorMessageWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Please Select Country Code",@"") delegate:nil];
    }
    else
    {
        
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
            [self mobieVerfifiedFoResigter];
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:NSLocalizedString(@"Please check your internet", @"") delegate:nil];
    }
}

-(void)mobieVerfifiedFoResigter
{
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:X_API_KEY  forKey:@"X-API-KEY"];
    [dictParams setObject:@"application/json"  forKey:@"Content-Type"];
    [dictParams setObject:self.mobile_TXT.text  forKey:@"mobile"];
    [dictParams setObject:CountryCodeId  forKey:@"country_id"];
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@",MobileVerifiedURL] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleMobileVerfyResponse:response];
     }];
}
- (void)handleMobileVerfyResponse:(NSDictionary*)response
{
    NSLog(@"register mobile Respose==%@",response);
    
    if ([[[response objectForKey:@"STATUS"]stringValue ] isEqualToString:@"200"])
    {
        customerId=[[response valueForKey:@"DATA"] valueForKey:@"id"];
        NSLog(@"customerId==%@",customerId);
         VerificationPOPupView.hidden=NO;
         [AppDelegate showErrorMessageWithTitle:@"SEND" message:[response objectForKey:@"MSG"] delegate:nil];
        
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:NSLocalizedString(@"Error", @"") message:[response objectForKey:@"MSG"] delegate:nil];
    }
}

#pragma mark -Verfied Code
- (IBAction)Verified_Click:(id)sender
{
    [self.VerificatonTXT resignFirstResponder];
    if ([self.VerificatonTXT.text isEqualToString:@""])
    {
        //[self ShowPOPUP];
        
        [AppDelegate showErrorMessageWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Please enter verification mobile number code",@"") delegate:nil];
    }
    else
    {
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
            [self VerifiedCode:customerId];
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:NSLocalizedString(@"Please check your internet", @"") delegate:nil];
    }
    
}
-(void)VerifiedCode:(NSString *)cutomerID
{
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:X_API_KEY  forKey:@"X-API-KEY"];
    [dictParams setObject:@"application/json"  forKey:@"Content-Type"];
    [dictParams setObject:VerificatonTXT.text  forKey:@"code"];
    [dictParams setObject:cutomerID  forKey:@"customer_id"];
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@",CheckVerifiedCodeURL] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleRegisterMobileResponse:response];
     }];
}
- (void)handleRegisterMobileResponse:(NSDictionary*)response
{
    NSLog(@"go nxt regstr Respose==%@",response);
    
    if ([[[response objectForKey:@"STATUS"]stringValue ] isEqualToString:@"200"])
    {
        [VerificatonTXT resignFirstResponder];
        VerificationPOPupView.hidden=YES;
        RegistrationVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RegistrationVW"];
        vcr.CustomerID=customerId;
        
        [self.navigationController pushViewController:vcr animated:YES];
        [AppDelegate showErrorMessageWithTitle:@"Success" message:[response objectForKey:@"MSG"] delegate:nil];
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
    [Country_BTN setTitle:[[CountryCodeDATA valueForKey:@"code"] objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    CountryCodeId=[[CountryCodeDATA valueForKey:@"id"] objectAtIndex:indexPath.row];
    PopupView.hidden=YES;
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

- (IBAction)CountryBTN_Click:(id)sender
{
    PopupView.hidden=NO;
    [self.mobile_TXT resignFirstResponder];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    PopupView.hidden=YES;
    VerificationPOPupView.hidden=YES;
    [VerificatonTXT resignFirstResponder];
    [self.mobile_TXT resignFirstResponder];
}
@end
