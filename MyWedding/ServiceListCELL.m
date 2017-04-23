//
//  ServiceListCELL.m
//  KScrollableTopMenuDemo
//
//  Created by Mango SW on 03/04/2017.
//  Copyright © 2017 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import "ServiceListCELL.h"

@implementation ServiceListCELL
@synthesize ServiceImage;
- (void)awakeFromNib
{
    [super awakeFromNib];
    ServiceImage.layer.cornerRadius=37.5f;
    ServiceImage.layer.borderWidth=2.0;
    ServiceImage.layer.masksToBounds = YES;
    ServiceImage.layer.borderColor=[[UIColor blackColor] CGColor];
    
  

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
