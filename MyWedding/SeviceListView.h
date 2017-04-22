//
//  SeviceListView.h
//  KScrollableTopMenuDemo
//
//  Created by Mango SW on 03/04/2017.
//  Copyright © 2017 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeviceListView : UIViewController
{
    NSMutableArray *HotelDescrition;
    NSMutableDictionary *ServicesListDATA,*MainServiceDIC;
}
@property (strong, nonatomic) NSString *TitleTXT;
@property (strong, nonatomic) NSString *CatID;


@property (weak, nonatomic) IBOutlet UITableView *ListTableView;
@property (weak, nonatomic) IBOutlet UILabel *Title_LBL;

@end
