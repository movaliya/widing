//
//  ServiceDetailView.h
//  MyWedding
//
//  Created by Mango SW on 04/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceDetailView : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *Title_LBL;
@property (weak, nonatomic) IBOutlet UITableView *ServiceDetialTABLE;
@property (strong, nonatomic) NSString *HotelTitleTXT;
@property (strong, nonatomic) NSString *HotelDescritionTXT;


@end
