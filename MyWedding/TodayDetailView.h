//
//  TodayDetailView.h
//  MyWedding
//
//  Created by Mango SW on 27/06/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayDetailView : UIViewController
{
    NSMutableDictionary *TodayEventDetail;
}
@property (weak, nonatomic) IBOutlet UIImageView *EventIMG;
@property (weak, nonatomic) IBOutlet UILabel *HostName;
@property (weak, nonatomic) IBOutlet UILabel *Address;
@property (weak, nonatomic) IBOutlet UILabel *EventName;
@property (weak, nonatomic) IBOutlet UILabel *EventDate;
@property (weak, nonatomic) IBOutlet UILabel *Contact;
@property (weak, nonatomic) IBOutlet UILabel *EventDetail;

@property (strong, nonatomic) NSString *EventID;
@end
