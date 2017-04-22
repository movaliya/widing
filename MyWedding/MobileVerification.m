//
//  MobileVerification.m
//  MyWedding
//
//  Created by Mango SW on 20/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "MobileVerification.h"
#import "MyWedding.pch"

@interface MobileVerification ()

@end

@implementation MobileVerification

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCoutryCode];
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
