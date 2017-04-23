//
//  ServiceDetailCELL.m
//  MyWedding
//
//  Created by Mango SW on 04/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "ServiceDetailCELL.h"

@implementation ServiceDetailCELL
@synthesize detailImage;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    detailImage.layer.cornerRadius=37.5f;
    detailImage.layer.borderWidth=2.0;
    detailImage.layer.masksToBounds = YES;
    detailImage.layer.borderColor=[[UIColor blackColor] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
