//
//  MBXFreeButtonsViewController.m
//  MBXPageViewController
//
//  Created by Nico Arqueros on 12/16/14.
//  Copyright (c) 2014 Moblox. All rights reserved.
//

#import "MBXFreeButtonsViewController.h"
#import "MBXPageViewController.h"
#import "TodayView.h"
#import "UpcomingView.h"
#import "ServicesView.h"
#import "MeView.h"
#import "SettingView.h"

@interface MBXFreeButtonsViewController () <MBXPageControllerDataSource>


@property (weak, nonatomic) IBOutlet UIButton *TodayBTN;
@property (weak, nonatomic) IBOutlet UIButton *UpComingBTN;
@property (weak, nonatomic) IBOutlet UIButton *Service_BTN;
@property (weak, nonatomic) IBOutlet UIButton *Me_BTN;

@property (strong, nonatomic) IBOutlet UILabel *Today_LBL;
@property (strong, nonatomic) IBOutlet UILabel *upcoming_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Service_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Me_LBL;


@property (weak, nonatomic) IBOutlet UIView *container;

@end

@implementation MBXFreeButtonsViewController

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //    return UIStatusBarStyleDefault;
}

-(void)ChangeTab:(NSNotification *) notification
{
    NSDictionary* userInfo = notification.userInfo;
    NSString* total = userInfo[@"total"];
    
    [self Hireallseprator];
    if ([total isEqualToString:@"0"])
    {
        self.Today_LBL.hidden=NO;
    }
    else if ([total isEqualToString:@"1"])
    {
         self.upcoming_LBL.hidden=NO;
    }
    else if ([total isEqualToString:@"2"])
    {
        self.Service_LBL.hidden=NO;
    }
    else if ([total isEqualToString:@"3"])
    {
        self.Me_LBL.hidden=NO;
    }
}

-(void)Hireallseprator
{
    self.Today_LBL.hidden=YES;
    self.upcoming_LBL.hidden=YES;
    self.Service_LBL.hidden=YES;
    self.Me_LBL.hidden=YES;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self Hireallseprator];
    self.Today_LBL.hidden=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeTab:) name:@"ChangeTab" object:nil];

    // Initiate MBXPageController
    MBXPageViewController *MBXPageController = [MBXPageViewController new];
    MBXPageController.MBXDataSource = self;
    [MBXPageController reloadPages];
}

#pragma mark - MBXPageViewController Data Source

- (NSArray *)MBXPageButtons
{
    return @[self.TodayBTN, self.UpComingBTN, self.Service_BTN,self.Me_BTN];
}

- (UIView *)MBXPageContainer
{
    return self.container;
}

- (NSArray *)MBXPageControllers
{
    TodayView *Todayvcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayView"];
     UpcomingView *upcomvcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UpcomingView"];
     ServicesView *servicevcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ServicesView"];
     MeView *mevcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MeView"];
    
    
    // The order matters.
    return @[Todayvcr,upcomvcr, servicevcr,mevcr];
}
- (IBAction)SettingBtn_Action:(id)sender
{
    NSLog(@"setting btn click");
    SettingView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingView"];
    [self.navigationController pushViewController:vcr animated:YES];
}

@end
