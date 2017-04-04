//
//  MeView.m
//  MyWedding
//
//  Created by kaushik on 02/04/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "MeView.h"

@interface MeView ()

@end

@implementation MeView
@synthesize FirstName_TXT,MobileNo_TXT,MiddleName_TXT,LastName_TXT,Email_TXT;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    FirstName_TXT.text=@"Abdul";
    MiddleName_TXT.text=@"Rehman";
    LastName_TXT.text=@"Mohamed";
    MobileNo_TXT.text=@"00974 12345678";
    Email_TXT.text=@"user@domain.com";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
