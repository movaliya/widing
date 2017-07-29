//
//  ViewController.m
//  MyWedding
//
//  Created by kaushik on 01/04/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "TodayView.h"
#import "UpcomingCell.h"
#import "MyWedding.pch"
#import <EventKitUI/EventKitUI.h>
#import "TodayDetailView.h"

@interface TodayView ()<EKEventViewDelegate,EKEventEditViewDelegate>

@end

@implementation TodayView
@synthesize TodayTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.NotificationLabel setHidden:YES];
   
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
        [self performSelector:@selector(getTodayEvent) withObject:nil afterDelay:0.0];
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:NSLocalizedString(@"Please check your internet", @"") delegate:nil];
    
    
    UINib *nib = [UINib nibWithNibName:@"UpcomingCell" bundle:nil];
    UpcomingCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    TodayTableView.rowHeight = cell.frame.size.height;
    [TodayTableView registerNib:nib forCellReuseIdentifier:@"UpcomingCell"];
    
}
-(void)getTodayEvent
{
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [currentDefaults objectForKey:@"USERDATADICT"];
    NSDictionary* userData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString *cutmrID=[userData valueForKey:@"id"];
    
    NSString *newToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERTOKEN"];
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:newToken  forKey:@"X-API-KEY"];
    [dictParams setObject:@"application/json"  forKey:@"Content-Type"];
    [dictParams setObject:cutmrID  forKey:@"customer_id"];
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
        NSLog(@"TodayEventDATA==%@",TodayEventDATA);
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
        [AppDelegate showErrorMessageWithTitle:@"" message:[response objectForKey:@"MSG"] delegate:nil];
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
    static NSString *CellIdentifier = @"UpcomingCell";
    UpcomingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.hostName.text=[[TodayEventDATA valueForKey:@"host_name"]objectAtIndex:indexPath.section];
    cell.EventName.text=[[TodayEventDATA valueForKey:@"name"]objectAtIndex:indexPath.section];
    cell.address.text=[[TodayEventDATA valueForKey:@"address"]objectAtIndex:indexPath.section];
    cell.DateLBL.text=[[TodayEventDATA valueForKey:@"date"]objectAtIndex:indexPath.section];
    cell.timeLBL.text=[[TodayEventDATA valueForKey:@"contact"]objectAtIndex:indexPath.section];
    
    cell.EventImage.layer.backgroundColor=[[UIColor clearColor] CGColor];    
    [cell.CalenderBTN addTarget:self action:@selector(CalenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.CalenderBTN.tag=indexPath.section;
    
    NSArray *dic;
    for (dic in [TodayEventDATA valueForKey:@"img"])
    {
        for (NSDictionary *dics in dic)
        {
            NSString *Urlstr=[dics valueForKey:@"url"];
            [cell.EventImage sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
            [cell.EventImage setShowActivityIndicatorView:YES];
            NSLog(@"dic=%@",dics);
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodayDetailView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayDetailView"];
    vcr.EventID=[NSString stringWithFormat:@"%@",[[TodayEventDATA valueForKey:@"id"]objectAtIndex:indexPath.section]];
    [self.navigationController pushViewController:vcr animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 114;
    
}
-(void)CalenBtnClick:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    SelectEventIndex=senderButton.tag;
    
    EKEventStore *store = [[EKEventStore alloc] init];
    
    if([store respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        // iOS 6
        [store requestAccessToEntityType:EKEntityTypeEvent
                              completion:^(BOOL granted, NSError *error)
         {
             if (granted)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self createEventAndPresentViewController:store];
                 });
             }
         }];
    } else
    {
        // iOS 5
        [self createEventAndPresentViewController:store];
    }
    
}
- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createEventAndPresentViewController:(EKEventStore *)store
{
    EKEvent *event = [self findOrCreateEvent:store];
    
    EKEventEditViewController *controller = [[EKEventEditViewController alloc] init];
    controller.event = event;
    controller.eventStore = store;
    controller.editViewDelegate = self;
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (EKEvent *)findOrCreateEvent:(EKEventStore* )store
{
    
    
    
    NSString *title =  [[TodayEventDATA valueForKey:@"host_name"]objectAtIndex:SelectEventIndex];
    
    // try to find an event
    
    EKEvent *event = [self findEventWithTitle:title inEventStore:store];
    
    // if found, use it
    
    if (event)
    {
        return event;
    }
    
    // if not, let's create new event
    
    NSString *DateStr=[[TodayEventDATA valueForKey:@"date"]objectAtIndex:SelectEventIndex];
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:DateStr];
    
    
    event = [EKEvent eventWithEventStore:store];
    
    event.title = title;
    event.notes = [[TodayEventDATA valueForKey:@"details"]objectAtIndex:SelectEventIndex];
    event.location = [[TodayEventDATA valueForKey:@"address"]objectAtIndex:SelectEventIndex];
    event.calendar = [store defaultCalendarForNewEvents];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = 4;
    event.startDate =date;
    components.hour = 1;
    event.endDate = [calendar dateByAddingComponents:components
                                              toDate:event.startDate
                                             options:0];
    
    return event;
}

- (EKEvent *)findEventWithTitle:(NSString *)title inEventStore:(EKEventStore *)store
{
    // Get the appropriate calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Create the start range date components
    NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
    oneDayAgoComponents.day = -1;
    NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents
                                                  toDate:[NSDate date]
                                                 options:0];
    
    // Create the end range date components
    NSDateComponents *oneWeekFromNowComponents = [[NSDateComponents alloc] init];
    oneWeekFromNowComponents.day = 7;
    NSDate *oneWeekFromNow = [calendar dateByAddingComponents:oneWeekFromNowComponents
                                                       toDate:[NSDate date]
                                                      options:0];
    
    // Create the predicate from the event store's instance method
    NSPredicate *predicate = [store predicateForEventsWithStartDate:oneDayAgo
                                                            endDate:oneWeekFromNow
                                                          calendars:nil];
    
    // Fetch all events that match the predicate
    NSArray *events = [store eventsMatchingPredicate:predicate];
    
    for (EKEvent *event in events)
    {
        if ([title isEqualToString:event.title])
        {
            return event;
        }
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
