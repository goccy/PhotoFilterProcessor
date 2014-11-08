//
//  CIOverlayBlendModeView.m
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/25.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "CIOverlayBlendModeView.h"
#import "SelectPhotoViewController.h"
#import "EditFilterViewController.h"
#import "ImageSelector.h"

@implementation CIOverlayBlendModeView

static NSString *FILTER_NAME     = @"CIOverlayBlendMode";
static NSString *CELL_IDENTIFIER = @"Cell";

- (id)initWithFrame:(CGRect)frame filterParams:(NSArray *)filterParams
{
    CIOverlayBlendModeView *loadedView = [[CIOverlayBlendModeView alloc] initWithNibName:@"CIOverlayBlendModeView"];
    self = [super initWithFrame:frame];
    self.frame = loadedView.frame;
    self.collectionView   = loadedView.collectionView;
    self.collectionView.backgroundColor = [UIColor tabThemeColor];
    self.loadBlendImageButton  = loadedView.loadBlendImageButton;
    self.backgroundColor  = [UIColor whiteColor];
    self.filterName = FILTER_NAME;
    [self.loadBlendImageButton singleTap:^(UIGestureRecognizer *singleTap) {
        SelectPhotoViewController *selectPhotoVC = [[SelectPhotoViewController alloc] initWithNibName:@"SelectPhotoViewController" bundle:nil];
        selectPhotoVC.loadedImage = ^(ALAsset *loadedImageAsset) {
            [self.blendImages addObject:[loadedImageAsset imageBasePath]];
            [self filter];
            [self.collectionView reloadData];
        };
        UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:selectPhotoVC];
        [self.editFilterVC.navigationController presentViewController:naviVC animated:YES completion:nil];
    }];
    
    [self addSubview:loadedView];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    self.collectionView.delegate   = self;
    self.collectionView.dataSource = self;
    self.blendImages = [[NSMutableArray alloc] init];
    for (NSDictionary *filterParam in filterParams) {
        NSString *blendImagePath = filterParam[@"inputBackgroundImage"];
        [self.blendImages addObject:blendImagePath];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.blendImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    for (UIView *subview in cell.subviews) {
        [subview removeFromSuperview];
    }
    UIImageView *deletePhotoButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    deletePhotoButton.image        = [UIImage imageNamed:@"delete-photo.png"];
    deletePhotoButton.contentMode  = UIViewContentModeScaleAspectFit;
    deletePhotoButton.userInteractionEnabled = YES;
    [deletePhotoButton singleTap:^(UIGestureRecognizer *sender) {
        [cell removeFromSuperview];
        [self.blendImages removeObjectAtIndex:indexPath.row];
        [self filter];
        [self.collectionView reloadData];
    }];
    
    UIImageView *imageView   = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
    imageView.contentMode    = UIViewContentModeScaleAspectFill;
    NSString *imageBasePath  = self.blendImages[indexPath.row];
    NSString *imagePath      = [ALAsset fullScreenImageSavePathWithBasePath:imageBasePath];
    imageView.image          = [UIImage imageWithContentsOfFile:imagePath];
    [cell addSubview:imageView];
    [cell addSubview:deletePhotoButton];
    cell.clipsToBounds = YES;
    return cell;
}

- (void)filter
{
    NSMutableArray *filterParams = [[NSMutableArray alloc] init];
    for (NSString *blendImagePath in self.blendImages) {
        [filterParams addObject:@{ @"inputBackgroundImage" : blendImagePath }];
    }
    [self.editFilterVC changedParameterWithFilterName:self.filterName params:filterParams];
}

@end
