//
//  SettingView.m
//  MyWedding
//
//  Created by Mango SW on 04/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "SettingView.h"

@interface SettingView ()

@end

@implementation SettingView

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)ChangePassword_Action:(id)sender {
}
- (IBAction)ShareApp_Action:(id)sender {
}
- (IBAction)SignOut_Action:(id)sender {
}


- (IBAction)Back_Btn_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
