//
//  ServiceDetailView.m
//  MyWedding
//
//  Created by Mango SW on 04/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "ServiceDetailView.h"
#import "ServiceDetailCELL.h"
@interface ServiceDetailView ()

@end

@implementation ServiceDetailView
@synthesize ServiceDetialTABLE,Title_LBL;

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Title_LBL.text=self.HotelTitleTXT;
    
    UINib *nib = [UINib nibWithNibName:@"ServiceDetailCELL" bundle:nil];
    ServiceDetailCELL *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    [ServiceDetialTABLE registerNib:nib forCellReuseIdentifier:@"ServiceDetailCELL"];
    
    ServiceDetialTABLE.rowHeight = UITableViewAutomaticDimension;
    ServiceDetialTABLE.estimatedRowHeight = 255.0;
}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    static NSString *CellIdentifier = @"ServiceDetailCELL";
    ServiceDetailCELL *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    cell.Description.text=self.HotelDescritionTXT;
    [cell updateConstraintsIfNeeded];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"ServiceDetailCELL";
    ServiceDetailCELL *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
  
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    
       [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
   
    height += 1.0f;
    
    return height;
}

- (IBAction)Back_BTN_Action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
