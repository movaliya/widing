//
//  ViewController.h
//  MyWedding
//
//  Created by kaushik on 01/04/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayView : UIViewController
{
    NSMutableDictionary *TodayEventDATA;
    NSInteger SelectEventIndex;

}
@property (weak, nonatomic) IBOutlet UILabel *NotificationLabel;
@property (weak, nonatomic) IBOutlet UITableView *TodayTableView;


@end

