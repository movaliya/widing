//
//  ServiceDetailCELL.h
//  MyWedding
//
//  Created by Mango SW on 04/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceDetailCELL : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Description;
@property (weak, nonatomic) IBOutlet UIImageView *detailImage;
@property (weak, nonatomic) IBOutlet UILabel *detailName;
@property (weak, nonatomic) IBOutlet UILabel *detailAddress;
@property (weak, nonatomic) IBOutlet UILabel *DetailURL;
@property (weak, nonatomic) IBOutlet UILabel *DetailDescription;
@property (weak, nonatomic) IBOutlet UILabel *detailNumber;

@end
