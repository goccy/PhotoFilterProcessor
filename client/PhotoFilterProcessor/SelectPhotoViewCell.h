//
//  SelectPhotoViewCell.h
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2013/12/11.
//  Copyright (c) 2013年 masaaki goshima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectPhotoViewController.h"

@class ALAsset;
@interface SelectPhotoViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, strong) ALAsset *asset;

@end
