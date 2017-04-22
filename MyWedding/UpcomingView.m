//
//  UpcomingView.m
//  MyWedding
//
//  Created by kaushik on 02/04/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "UpcomingView.h"
#import "UpcomingCell.h"
#import "MyWedding.pch"

@interface UpcomingView ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation UpcomingView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
     [self upComingEvent];
    
    UINib *nib = [UINib nibWithNibName:@"UpcomingCell" bundle:nil];
    UpcomingCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    _tableView.rowHeight = cell.frame.size.height;
    [_tableView registerNib:nib forCellReuseIdentifier:@"UpcomingCell"];
}
-(void)upComingEvent
{
    NSString *newToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERTOKEN"];
    
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [currentDefaults objectForKey:@"USERDATADICT"];
    NSDictionary* userData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString *cutmrID=[userData valueForKey:@"id"];

    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:newToken  forKey:@"X-API-KEY"];
    [dictParams setObject:@"application/json"  forKey:@"Content-Type"];
    [dictParams setObject:cutmrID  forKey:@"customer_id"];
    [dictParams setObject:@"1"  forKey:@"list_type"];//This for Futrue Event only 1
    [dictParams setObject:@"0"  forKey:@"page_id"];// this for 1 to 10 only
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@",getEventsURL] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleFutureEventResponse:response];
     }];
}
- (void)handleFutureEventResponse:(NSDictionary*)response
{
    
    if ([[[response objectForKey:@"STATUS"]stringValue ] isEqualToString:@"200"])
    {
        FutureEventDATA=[response valueForKey:@"DATA"];
         NSLog(@"TodayEventDATA count==%@",FutureEventDATA);
        if (FutureEventDATA.count>0)
        {
           // [self.NotificationLabel setHidden:YES];
        }
        else
        {
           // [self.NotificationLabel setHidden:NO];
        }
        [self.tableView reloadData];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:@"ERROR" message:[response objectForKey:@"MSG"] delegate:nil];
    }
    
}
#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return FutureEventDATA.count;
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
    static NSString *CellIdentifier = @"UpcomingCell";
    UpcomingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.hostName.text=[[FutureEventDATA valueForKey:@"host_name"]objectAtIndex:indexPath.section];
    cell.EventName.text=[[FutureEventDATA valueForKey:@"name"]objectAtIndex:indexPath.section];
    cell.address.text=[[FutureEventDATA valueForKey:@"address"]objectAtIndex:indexPath.section];
    cell.DateLBL.text=[[FutureEventDATA valueForKey:@"date"]objectAtIndex:indexPath.section];
    cell.timeLBL.text=[[FutureEventDATA valueForKey:@"contact"]objectAtIndex:indexPath.section];
    
    cell.EventImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
    cell.EventImage.layer.cornerRadius=36;
    cell.EventImage.layer.borderWidth=2.0;
    cell.EventImage.layer.masksToBounds = YES;
    cell.EventImage.layer.borderColor=[[UIColor blackColor] CGColor];
    
    NSMutableArray *imgDic=[[FutureEventDATA valueForKey:@"img"] objectAtIndex:indexPath.section];
    NSDictionary *tempdic=[imgDic mutableCopy];
    NSString *Urlstr=[tempdic valueForKey:@"url"];
    
    [cell.EventImage sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
    [cell.EventImage setShowActivityIndicatorView:YES];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 114;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
