//
//  RegistrationVW.m
//  MyWedding
//
//  Created by Mango SW on 20/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "RegistrationVW.h"
#import "MyWedding.pch"
@interface RegistrationVW ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *myPickerView;
    NSMutableArray *years;
}
@end

@implementation RegistrationVW
@synthesize FirstNameTXT,SecondNameTXT,MiddleNameTXT,LastNameTXT,PasswordTXT,EmailTXT,VillNoTXT,AreaTXT,StreetNameTXT,DateOfYearTXT,ZoneTXT,ConfrimPasswordTXT;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    int i2  = [[formatter stringFromDate:[NSDate date]] intValue];
    
    [myPickerView selectRow:i2 inComponent:0 animated:NO];
    
    //Create Years Array from 1960 to This year
    years = [[NSMutableArray alloc] init];
    for (int i=1900; i<=i2; i++)
    {
        [years addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    [myPickerView selectRow:years.count-19 inComponent:0 animated:YES];
    [DateOfYearTXT setInputView: myPickerView];
    [myPickerView reloadAllComponents];
    
}

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView*)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [years count];
}
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [years objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *YearStr=[NSString stringWithFormat:@"%@",[years objectAtIndex:row]];
    DateOfYearTXT.text=YearStr;
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
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Year of Birth" delegate:nil];
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
        else if (![PasswordTXT.text isEqualToString:ConfrimPasswordTXT.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Password does not match the confirm password." delegate:nil];
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
    
    [dictParams setObject:@"102"  forKey:@"customer_id"]; // Custmer ID to Replace dynamic after testing complete
    [dictParams setObject:FirstNameTXT.text  forKey:@"first_name"];
    [dictParams setObject:SecondNameTXT.text  forKey:@"second_name"];
    [dictParams setObject:MiddleNameTXT.text  forKey:@"middle_name"];
    
    [dictParams setObject:LastNameTXT.text  forKey:@"last_name"];
    [dictParams setObject:PasswordTXT.text  forKey:@"password"];
    [dictParams setObject:DateOfYearTXT.text  forKey:@"date_of_year"];
    [dictParams setObject:EmailTXT.text  forKey:@"email"];
    
    [dictParams setObject:DEVICETOKEN  forKey:@"device_token"];
    [dictParams setObject:@"ios"  forKey:@"device_type"];// This is a static string for Device is IOS or Android
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
