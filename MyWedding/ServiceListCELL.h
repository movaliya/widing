//
//  ServiceListCELL.h
//  KScrollableTopMenuDemo
//
//  Created by Mango SW on 03/04/2017.
//  Copyright © 2017 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceListCELL : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ServiceImage;
@property (weak, nonatomic) IBOutlet UILabel *ServiceTitle;
@property (weak, nonatomic) IBOutlet UILabel *serviceNumber;
@property (weak, nonatomic) IBOutlet UILabel *ServiceDetail;
@property (weak, nonatomic) IBOutlet UIButton *ServiceCallBTN;

@end
