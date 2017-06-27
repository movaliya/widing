//
//  UpcomingCell.h
//  KScrollableTopMenuDemo
//
//  Created by Mango SW on 02/04/2017.
//  Copyright © 2017 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpcomingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *EventImage;
@property (weak, nonatomic) IBOutlet UILabel *hostName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *EventName;
@property (weak, nonatomic) IBOutlet UILabel *DateLBL;
@property (weak, nonatomic) IBOutlet UILabel *timeLBL;
@property (weak, nonatomic) IBOutlet UIButton *CalenderBTN;

@end
