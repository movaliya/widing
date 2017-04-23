//
//  SeviceListView.m
//  KScrollableTopMenuDemo
//
//  Created by Mango SW on 03/04/2017.
//  Copyright © 2017 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import "SeviceListView.h"
#import "ServiceListCELL.h"
#import "ServiceDetailView.h"
#import "MyWedding.pch"
#import <QuartzCore/QuartzCore.h>

@interface SeviceListView ()

@end

@implementation SeviceListView
@synthesize ListTableView;
@synthesize Title_LBL;

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
        [self GetServicesList];
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    
    
    Title_LBL.text=self.TitleTXT;
    UINib *nib = [UINib nibWithNibName:@"ServiceListCELL" bundle:nil];
    ServiceListCELL *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    ListTableView.rowHeight = cell.frame.size.height;
    [ListTableView registerNib:nib forCellReuseIdentifier:@"ServiceListCELL"];
    ListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    HotelDescrition=[[NSMutableArray alloc]initWithObjects:@"Situated on the shores of West Bay and the sparkling blue waters of the Arabian Gulf, the landmark 5-star Sheraton Grand Doha has been restored to its former glory, preserving its authenticity while cutting-edge amenities and facilities cater to today’s international traveller.\nThe hotel is home to ten restaurants, bars and lounges including Latino Steakhouse, one of the best South American restaurants in the city, the truly Italian La Veranda and Irish Harp, Doha’s popular Irish pub.\nRefresh your taste buds with our two new restaurants, Nusr-Et Steakhouse and Em-Sherif  (coming soon) replacing your old favourites Al Maskar and Al Shaheen!",@"preserving its authenticity while cutting-edge amenities and facilities cater to today’s international traveller.\nThe hotel is home to ten restaurants, bars and lounges including Latino Steakhouse, one of the best South American restaurants in the city, the truly Italian La Veranda and Irish Harp,",nil];
}
-(void)GetServicesList
{
    NSString *newToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERTOKEN"];
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:newToken  forKey:@"X-API-KEY"];
    [dictParams setObject:@"application/json"  forKey:@"Content-Type"];
    [dictParams setObject:self.CatID  forKey:@"category_id"];
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@",ServicesListURL] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleServicesListResponse:response];
     }];
}

- (void)handleServicesListResponse:(NSDictionary*)response
{
    NSLog(@"Cate Respose==%@",response);
    
    if ([[[response objectForKey:@"STATUS"]stringValue ] isEqualToString:@"200"])
    {
        ServicesListDATA=[response valueForKey:@"DATA"];
        MainServiceDIC=[response mutableCopy];
        [self.ListTableView reloadData];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:@"ERROR" message:[response objectForKey:@"MSG"] delegate:nil];
    }
    
}
#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ServicesListDATA.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ServiceListCELL";
    ServiceListCELL *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.ServiceTitle.text=[[ServicesListDATA valueForKey:@"name"]objectAtIndex:indexPath.section];
    cell.serviceNumber.text=[[ServicesListDATA valueForKey:@"contact"]objectAtIndex:indexPath.section];
    cell.ServiceDetail.text=[[ServicesListDATA valueForKey:@"address"]objectAtIndex:indexPath.section];
    
    
    
    NSString *Urlstr=[[ServicesListDATA valueForKey:@"img"] objectAtIndex:indexPath.section];
    [cell.ServiceImage sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
    [cell.ServiceImage setShowActivityIndicatorView:YES];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceDetailView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ServiceDetailView"];
    vcr.HotelTitleTXT=@"Sheraton Grand Doha";
    vcr.detailData=[[[MainServiceDIC valueForKey:@"DATA"]objectAtIndex:indexPath.section]mutableCopy];
    [self.navigationController pushViewController:vcr animated:YES];
}

- (IBAction)Back_BTN_Action:(id)sender
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
