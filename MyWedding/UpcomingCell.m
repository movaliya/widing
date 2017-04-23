//
//  UpcomingCell.m
//  KScrollableTopMenuDemo
//
//  Created by Mango SW on 02/04/2017.
//  Copyright © 2017 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import "UpcomingCell.h"

@implementation UpcomingCell
@synthesize EventImage;
- (void)awakeFromNib
{
    [super awakeFromNib];
    EventImage.layer.cornerRadius=50;
    EventImage.layer.borderWidth=2.0;
    EventImage.layer.masksToBounds = YES;
    EventImage.layer.borderColor=[[UIColor blackColor] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
