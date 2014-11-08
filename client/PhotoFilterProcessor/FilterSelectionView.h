//
//  FilterSelectionView.h
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/25.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditFilterViewController;
@interface FilterSelectionView : UICollectionView<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic) NSArray *filters;
@property(nonatomic) NSMutableDictionary *filterTable;
@property(nonatomic) CGFloat originalWidth;
@property(nonatomic) EditFilterViewController *editFilterVC;

- (id)initWithEditFilterVC:(EditFilterViewController *)editFilterVC;

@end
