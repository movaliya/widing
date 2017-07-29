//
//  ServicesView.m
//  MyWedding
//
//  Created by kaushik on 02/04/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "ServicesView.h"
#import "CVCell.h"
#import "SeviceListView.h"
#import "MyWedding.pch"

@interface ServicesView ()
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@end

@implementation ServicesView

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
        [self performSelector:@selector(getCategories) withObject:nil afterDelay:0.0];
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:NSLocalizedString(@"Please check your internet", @"") delegate:nil];
    
    [self.collectionView registerClass:[CVCell class] forCellWithReuseIdentifier:@"cvCell"];
    /* end of subclass-based cells block */
    
    // Configure layout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(200, 200)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flowLayout];
    NSLog(@"first view");
    // Do any additional setup after loading the view.
}

-(void)getCategories
{
    NSString *newToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERTOKEN"];

    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:newToken  forKey:@"X-API-KEY"];
    [dictParams setObject:@"application/json"  forKey:@"Content-Type"];
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@",CategoriesListURL] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleCategoriesResponse:response];
     }];
}
- (void)handleCategoriesResponse:(NSDictionary*)response
{
    NSLog(@"Cate Respose==%@",response);
    
    if ([[[response objectForKey:@"STATUS"]stringValue ] isEqualToString:@"200"])
    {
        CatDATA=[response valueForKey:@"DATA"];
        [self.collectionView reloadData];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:NSLocalizedString(@"Error", @"") message:[response objectForKey:@"MSG"] delegate:nil];
    }
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return CatDATA.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Setup cell identifier
    static NSString *cellIdentifier = @"cvCell";
    
    CVCell *cell = (CVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell.titleLabel setText:[[CatDATA valueForKey:@"name"] objectAtIndex:indexPath.row]];
    
    
    NSString *Urlstr=[[CatDATA valueForKey:@"img"] objectAtIndex:indexPath.row];
    
    [cell.IconImageview sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
    [cell.IconImageview setShowActivityIndicatorView:YES];
    
 //   NSString *imagename=[ImageNameSection objectAtIndex:indexPath.row];
   // UIImage *imge=[UIImage imageNamed:imagename];
    //[cell.IconImageview setImage:imge];
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SeviceListView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SeviceListView"];
    vcr.TitleTXT=[[CatDATA valueForKey:@"name"] objectAtIndex:indexPath.row];
    vcr.CatID=[[CatDATA valueForKey:@"id"] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vcr animated:YES];
}

#pragma mark Collection view layout things
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize mElementSize;
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        mElementSize = CGSizeMake(120, 120);
    }
    else if (IS_IPHONE_6)
    {
        mElementSize = CGSizeMake(140, 140);
    }
    else if (IS_IPHONE_6P)
    {
        mElementSize = CGSizeMake(150, 150);
    }
    return mElementSize;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        return UIEdgeInsetsMake(15,25,10,25);  // top, left, bottom, right
    }
    else if (IS_IPHONE_6)
    {
       return UIEdgeInsetsMake(15,28,10,28);  // top, left, bottom, right
    }
    else if (IS_IPHONE_6P)
    {
        return UIEdgeInsetsMake(15,33,10,33);  // top, left, bottom, right
    }

    return UIEdgeInsetsMake(15,25,10,25);  // top, left, bottom, right
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
