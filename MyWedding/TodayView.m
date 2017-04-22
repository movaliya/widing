//
//  ViewController.m
//  MyWedding
//
//  Created by kaushik on 01/04/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "TodayView.h"
#import "TodayCELL.h"
#import "MyWedding.pch"
@interface TodayView ()

@end

@implementation TodayView
@synthesize TodayTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.NotificationLabel setHidden:YES];
    [self getTodayEvent];
    
    
    UINib *nib = [UINib nibWithNibName:@"TodayCELL" bundle:nil];
    TodayCELL *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    TodayTableView.rowHeight = cell.frame.size.height;
    [TodayTableView registerNib:nib forCellReuseIdentifier:@"TodayCELL"];
}
-(void)getTodayEvent
{
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:X_API_KEY  forKey:@"X-API-KEY"];
    [dictParams setObject:@"application/json"  forKey:@"Content-Type"];
    [dictParams setObject:@"3"  forKey:@"customer_id"];
     [dictParams setObject:@"0"  forKey:@"list_type"];//This for Today Event only 0
     [dictParams setObject:@"0"  forKey:@"page_id"];// this for 1 to 10 only
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@",getEventsURL] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleTodayEventResponse:response];
     }];
}
- (void)handleTodayEventResponse:(NSDictionary*)response
{
    
    if ([[[response objectForKey:@"STATUS"]stringValue ] isEqualToString:@"200"])
    {
        TodayEventDATA=[response valueForKey:@"DATA"];
         // NSLog(@"TodayEventDATA count==%d",TodayEventDATA.count);
        if (TodayEventDATA.count>0)
        {
            [self.NotificationLabel setHidden:YES];
        }
        else
        {
             [self.NotificationLabel setHidden:NO];
        }
        [TodayTableView reloadData];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:@"ERROR" message:[response objectForKey:@"MSG"] delegate:nil];
    }
    
}
#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return TodayEventDATA.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    static NSString *CellIdentifier = @"TodayCELL";
    TodayCELL *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.HostName.text=[[TodayEventDATA valueForKey:@"host_name"]objectAtIndex:indexPath.section];
    cell.EventName.text=[[TodayEventDATA valueForKey:@"name"]objectAtIndex:indexPath.section];
    cell.Address.text=[[TodayEventDATA valueForKey:@"address"]objectAtIndex:indexPath.section];
    cell.dateLBL.text=[[TodayEventDATA valueForKey:@"date"]objectAtIndex:indexPath.section];
    cell.TimeLBL.text=[[TodayEventDATA valueForKey:@"contact"]objectAtIndex:indexPath.section];
    
    cell.EventImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
    cell.EventImage.layer.cornerRadius=36;
    cell.EventImage.layer.borderWidth=2.0;
    cell.EventImage.layer.masksToBounds = YES;
    cell.EventImage.layer.borderColor=[[UIColor blackColor] CGColor];
    NSString *Urlstr=[[[TodayEventDATA valueForKey:@"img"] valueForKey:@"url"] objectAtIndex:indexPath.section];
    [cell.EventImage sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
    [cell.EventImage setShowActivityIndicatorView:YES];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 250;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
