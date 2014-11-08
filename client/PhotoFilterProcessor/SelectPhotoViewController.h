//
//  SelectPhotoViewController.h
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2013/12/11.
//  Copyright (c) 2013年 masaaki goshima. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAssetsLibrary;

@interface SelectPhotoViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property(nonatomic) ALAssetsLibrary *library;
@property(nonatomic) NSMutableArray *photos;
@property(nonatomic) NSMutableArray *groups;
@property(nonatomic, strong) void(^loadedImage)(ALAsset *);

@end
