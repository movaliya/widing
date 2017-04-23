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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
