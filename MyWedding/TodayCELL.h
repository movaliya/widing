//
//  TodayCELL.h
//  MyWedding
//
//  Created by Mango SW on 04/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayCELL : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *EventImage;
@property (weak, nonatomic) IBOutlet UILabel *HostName;
@property (weak, nonatomic) IBOutlet UILabel *Address;
@property (weak, nonatomic) IBOutlet UILabel *EventName;
@property (weak, nonatomic) IBOutlet UILabel *dateLBL;
@property (weak, nonatomic) IBOutlet UILabel *TimeLBL;

@end
