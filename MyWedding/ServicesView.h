//
//  ServicesView.h
//  MyWedding
//
//  Created by kaushik on 02/04/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServicesView : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *ImageNameSection;
    NSMutableArray *TitleNameSection;
    NSMutableDictionary *CatDATA;
}

@end
