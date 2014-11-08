//
//  FilterSelectionView.m
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/25.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "FilterSelectionView.h"
#import "EditFilterViewController.h"
#import "CIColorControlsView.h"
#import "CIColorMonochromeView.h"
#import "CIOverlayBlendModeView.h"
#import "CIColorDodgeBlendModeView.h"
#import "CIColorMatrixView.h"
#import "CIExposureAdjustView.h"
#import "CIHueAdjustView.h"
#import "CISepiaToneView.h"
#import "CIGaussianBlurView.h"
#import "CIUnsharpMaskView.h"

@implementation FilterSelectionView

static NSString *CELL_IDENTIFIER = @"FILTER_CELL";

- (id)initWithEditFilterVC:(EditFilterViewController *)editFilterVC
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"FilterSelectionView" owner:nil options:nil] objectAtIndex:0];
    self.editFilterVC  = editFilterVC;
    self.backgroundColor = [UIColor whiteColor];
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    self.dataSource = self;
    self.delegate   = self;
    self.backgroundColor = [UIColor tabThemeColor];
    [self createFilterTable];
    return self;
}

- (void)createFilterTable
{
    NSMutableDictionary *filterTable = [[NSMutableDictionary alloc] init];
    filterTable[@"カラーコントロール"]  = NSStringFromSelector(@selector(colorControlsFilterView));
    filterTable[@"モノクロ化"]         = NSStringFromSelector(@selector(colorMonochromeFilterView));
    filterTable[@"オーバーレイ"]       = NSStringFromSelector(@selector(overlayBlendModeFilterView));
    filterTable[@"ドッジブレンド"]      = NSStringFromSelector(@selector(colorDodgeBlendModeFilterView));
    filterTable[@"カラーマトリクス"]    = NSStringFromSelector(@selector(colorMatrixFilterView));
    filterTable[@"露出調整"]           = NSStringFromSelector(@selector(exposureAdjustFilterView));
    filterTable[@"色相調整"]           = NSStringFromSelector(@selector(hueAdjustFilterView));
    filterTable[@"セピア調"]           = NSStringFromSelector(@selector(sepiaToneFilterView));
    filterTable[@"ガウスぼかし"]        = NSStringFromSelector(@selector(gaussianBlurFilterView));
    filterTable[@"アンシャープマスク"]   = NSStringFromSelector(@selector(unsharpMaskFilterView));
    self.filterTable = filterTable;
    self.filters = [filterTable allKeys];
};

- (UIView *)colorControlsFilterView
{
    CGRect editArea = self.editFilterVC.tabArea.frame;
    CGRect frame    = CGRectMake(0, 0, editArea.size.width, editArea.size.height);
    NSDictionary *filterParams = self.editFilterVC.filterContents[@"CIColorControls"];
    CIColorControlsView *view = [[CIColorControlsView alloc] initWithFrame:frame filterParams:filterParams];
    view.editFilterVC = self.editFilterVC;
    return view;
}

- (UIView *)exposureAdjustFilterView
{
    CGRect editArea = self.editFilterVC.tabArea.frame;
    CGRect frame    = CGRectMake(0, 0, editArea.size.width, editArea.size.height);
    NSDictionary *filterParams = self.editFilterVC.filterContents[@"CIExposureAdjust"];
    CIExposureAdjustView *view = [[CIExposureAdjustView alloc] initWithFrame:frame filterParams:filterParams];
    view.editFilterVC = self.editFilterVC;
    return view;
}

- (UIView *)hueAdjustFilterView
{
    CGRect editArea = self.editFilterVC.tabArea.frame;
    CGRect frame    = CGRectMake(0, 0, editArea.size.width, editArea.size.height);
    NSDictionary *filterParams = self.editFilterVC.filterContents[@"CIHueAdjust"];
    CIHueAdjustView *view = [[CIHueAdjustView alloc] initWithFrame:frame filterParams:filterParams];
    view.editFilterVC = self.editFilterVC;
    return view;
}

- (UIView *)colorMatrixFilterView
{
    CGRect editArea = self.editFilterVC.tabArea.frame;
    CGRect frame    = CGRectMake(0, 0, editArea.size.width, editArea.size.height);
    NSDictionary *filterParams = self.editFilterVC.filterContents[@"CIColorMatrix"];
    CIColorMatrixView *view = [[CIColorMatrixView alloc] initWithFrame:frame filterParams:filterParams];
    view.editFilterVC = self.editFilterVC;
    return view;
}

- (UIView *)colorMonochromeFilterView
{
    CGRect editArea = self.editFilterVC.tabArea.frame;
    CGRect frame    = CGRectMake(0, 0, editArea.size.width, editArea.size.height);
    NSDictionary *filterParams = self.editFilterVC.filterContents[@"CIColorMonochrome"];
    CIColorMonochromeView *view = [[CIColorMonochromeView alloc] initWithFrame:frame filterParams:filterParams];
    view.editFilterVC = self.editFilterVC;
    return view;
}

- (UIView *)sepiaToneFilterView
{
    CGRect editArea = self.editFilterVC.tabArea.frame;
    CGRect frame    = CGRectMake(0, 0, editArea.size.width, editArea.size.height);
    NSDictionary *filterParams = self.editFilterVC.filterContents[@"CISepiaTone"];
    CISepiaToneView *view = [[CISepiaToneView alloc] initWithFrame:frame filterParams:filterParams];
    view.editFilterVC = self.editFilterVC;
    return view;
}

- (UIView *)gaussianBlurFilterView
{
    CGRect editArea = self.editFilterVC.tabArea.frame;
    CGRect frame    = CGRectMake(0, 0, editArea.size.width, editArea.size.height);
    NSDictionary *filterParams = self.editFilterVC.filterContents[@"CIGaussianBlur"];
    CIGaussianBlurView *view = [[CIGaussianBlurView alloc] initWithFrame:frame filterParams:filterParams];
    view.editFilterVC = self.editFilterVC;
    return view;
}

- (UIView *)unsharpMaskFilterView
{
    CGRect editArea = self.editFilterVC.tabArea.frame;
    CGRect frame    = CGRectMake(0, 0, editArea.size.width, editArea.size.height);
    NSDictionary *filterParams = self.editFilterVC.filterContents[@"CIUnsharpMask"];
    CIUnsharpMaskView *view = [[CIUnsharpMaskView alloc] initWithFrame:frame filterParams:filterParams];
    view.editFilterVC = self.editFilterVC;
    return view;
}

- (UIView *)overlayBlendModeFilterView
{
    CGRect editArea = self.editFilterVC.tabArea.frame;
    CGRect frame    = CGRectMake(0, 0, editArea.size.width, editArea.size.height);
    NSArray *filterParams = self.editFilterVC.filterContents[@"CIOverlayBlendMode"];
    CIOverlayBlendModeView *view = [[CIOverlayBlendModeView alloc] initWithFrame:frame filterParams:filterParams];
    view.editFilterVC = self.editFilterVC;
    return view;
}

- (UIView *)colorDodgeBlendModeFilterView
{
    CGRect editArea = self.editFilterVC.tabArea.frame;
    CGRect frame    = CGRectMake(0, 0, editArea.size.width, editArea.size.height);
    NSArray *filterParams = self.editFilterVC.filterContents[@"CIColorDodgeBlendMode"];
    CIColorDodgeBlendModeView *view = [[CIColorDodgeBlendModeView alloc] initWithFrame:frame filterParams:filterParams];
    view.editFilterVC = self.editFilterVC;
    return view;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *filterName = self.filters[indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:12];
    int width = [filterName sizeWithAttributes:@{NSFontAttributeName:font}].width + 1;
    return CGSizeMake(width, 74);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    cell.y = 0;
    for (UIView *subview in cell.subviews) {
        [subview removeFromSuperview];
    }
    NSString *filterName = self.filters[indexPath.row];
    UILabel *nameLabel  = [[UILabel alloc] initWithFrame:cell.frame];
    nameLabel.x         = 0;
    nameLabel.font      = [UIFont systemFontOfSize:12];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text      = filterName;
    [cell addSubview:nameLabel];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.filters count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *filterName = self.filters[indexPath.row];
    SEL selector         = NSSelectorFromString(self.filterTable[filterName]);
    UIView *filterView   = (UIView *)[self performSelector:selector];
    [self.editFilterVC loadedFilterView:filterView];
}

#pragma clang diagnostic pop

@end
