//
//  UpcomingDetailVW.m
//  MyWedding
//
//  Created by Mango SW on 27/06/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "UpcomingDetailVW.h"
#import "MyWedding.pch"
#import <EventKitUI/EventKitUI.h>

@interface UpcomingDetailVW ()<EKEventViewDelegate,EKEventEditViewDelegate>

@end

@implementation UpcomingDetailVW
@synthesize EventID;
@synthesize EventIMG,EventDate,EventName,Contact,Address,HostName;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
        [self performSelector:@selector(upComingEvent) withObject:nil afterDelay:0.0];
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    // Do any additional setup after loading the view.
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
    [dictParams setObject:EventID  forKey:@"id"];
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@",getEventsURL] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleFutureEventResponse:response];
     }];
}
- (void)handleFutureEventResponse:(NSDictionary*)response
{
    
    if ([[[response objectForKey:@"STATUS"]stringValue ] isEqualToString:@"200"])
    {
        FutureEventDetail=[response valueForKey:@"DATA"];
        NSLog(@"FuturDetailEventDATA count==%@",FutureEventDetail);
        HostName.text=[[FutureEventDetail valueForKey:@"host_name"]objectAtIndex:0];
        EventName.text=[[FutureEventDetail valueForKey:@"name"]objectAtIndex:0];
        Address.text=[[FutureEventDetail valueForKey:@"address"]objectAtIndex:0];
        Contact.text=[[FutureEventDetail valueForKey:@"contact"]objectAtIndex:0];
        EventDate.text=[[FutureEventDetail valueForKey:@"host_name"]objectAtIndex:0];
        
        NSArray *dic;
        for (dic in [FutureEventDetail valueForKey:@"img"])
        {
            for (NSDictionary *dics in dic)
            {
                NSString *Urlstr=[dics valueForKey:@"url"];
                [EventIMG sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
                [EventIMG setShowActivityIndicatorView:YES];
                // NSLog(@"dic=%@",dics);
            }
        }
        
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:@"ERROR" message:[response objectForKey:@"MSG"] delegate:nil];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Calendar_Btn_Action:(id)sender
{
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
    
    NSString *title =  [[FutureEventDetail valueForKey:@"name"]objectAtIndex:0];
    
    // try to find an event
    
    EKEvent *event = [self findEventWithTitle:title inEventStore:store];
    
    // if found, use it
    
    if (event)
    {
        return event;
    }
    
    // if not, let's create new event
    
    NSString *DateStr=[[FutureEventDetail valueForKey:@"date"]objectAtIndex:0];
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:DateStr];
    
    
    event = [EKEvent eventWithEventStore:store];
    
    event.title = title;
    event.notes = [[FutureEventDetail valueForKey:@"details"]objectAtIndex:0];
    event.location = [[FutureEventDetail valueForKey:@"address"]objectAtIndex:0];
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
- (IBAction)BackBtn_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
