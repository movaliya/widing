//
//  UpcomingView.h
//  MyWedding
//
//  Created by kaushik on 02/04/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpcomingView : UIViewController

{
    NSMutableDictionary *FutureEventDATA;
    NSInteger SelectEventIndex;
}
@property (weak, nonatomic) IBOutlet UILabel *NotificationLabel;

@end
