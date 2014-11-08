//
//  EditFilterViewController.m
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/24.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "EditFilterViewController.h"
#import "FilterSelectionView.h"
#import "SelectPhotoViewController.h"
#import "UploadViewController.h"
#import "ImageSelector.h"
#import "PhotoFilterProcessor.h"
/*
#import <GLKit/GLKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
*/

@interface EditFilterViewController ()

@property(nonatomic) FilterSelectionView *filterSelectionView;
//@property(nonatomic) EAGLContext *ctx;

@end

@implementation EditFilterViewController

static const int CLOSE_BUTTON_WIDTH  = 80;
static const int CLOSE_BUTTON_HEIGHT = 40;
static const int FINISH_BUTTON_WIDTH  = 80;
static const int FINISH_BUTTON_HEIGHT = 40;

- (void)dropShadow
{
    CALayer* subLayer = [CALayer layer];
    subLayer.frame = self.baseImageView.bounds;
    subLayer.masksToBounds = YES;
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:
                          CGRectMake(-10.0, -10.0, subLayer.bounds.size.width+10.0, 10.0)];
    subLayer.shadowOffset = CGSizeMake(3, 3);
    subLayer.shadowColor = [[UIColor blackColor] CGColor];
    subLayer.shadowOpacity = 0.5;
    subLayer.shadowPath = [path CGPath];
    
    CALayer *subLayer2 = [CALayer layer];
    subLayer2.frame = self.baseImageView.bounds;
    subLayer2.masksToBounds = YES;
    path = [UIBezierPath bezierPathWithRect:
            CGRectMake(-10.0, subLayer.bounds.size.height - 5, subLayer.bounds.size.width + 10.0, 10.0)];
    subLayer2.shadowOffset = CGSizeMake(3, 3);
    subLayer2.shadowColor = [[UIColor blackColor] CGColor];
    subLayer2.shadowOpacity = 0.5;
    subLayer2.shadowPath = [path CGPath];
    
    CALayer *subLayer3 = [CALayer layer];
    subLayer3.frame = self.baseImageView.bounds;
    subLayer3.masksToBounds = YES;
    path = [UIBezierPath bezierPathWithRect:
            CGRectMake(-10.0, 0, 10.0, subLayer.bounds.size.height)];
    subLayer3.shadowOffset = CGSizeMake(3, 3);
    subLayer3.shadowColor = [[UIColor blackColor] CGColor];
    subLayer3.shadowOpacity = 0.5;
    subLayer3.shadowPath = [path CGPath];
    
    CALayer *subLayer4 = [CALayer layer];
    subLayer4.frame = self.baseImageView.bounds;
    subLayer4.masksToBounds = YES;
    path = [UIBezierPath bezierPathWithRect:
            CGRectMake(subLayer.bounds.size.width - 6.0f, 0, 10.0f, subLayer.bounds.size.height)];
    subLayer4.shadowOffset = CGSizeMake(3, 3);
    subLayer4.shadowColor = [[UIColor blackColor] CGColor];
    subLayer4.shadowOpacity = 0.5;
    subLayer4.shadowPath = [path CGPath];

    [self.baseImageView.layer addSublayer:subLayer];
    [self.baseImageView.layer addSublayer:subLayer2];
    [self.baseImageView.layer addSublayer:subLayer3];
    [self.baseImageView.layer addSublayer:subLayer4];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sliderView          = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tabArea.width, self.tabArea.height)];
    self.sliderView.hidden   = YES;
    self.view.backgroundColor = [UIColor backgroundThemeColor];
    self.baseImageView.backgroundColor = [UIColor backgroundThemeColor];
    [self dropShadow];
    self.baseImageView.layer.cornerRadius = 5;
    self.baseImageView.clipsToBounds = true;
    self.tabArea.backgroundColor = [UIColor tabThemeColor];
    self.loadImageButton.backgroundColor = [UIColor tabThemeColor];

    self.filterSelectionView = [[FilterSelectionView alloc] initWithEditFilterVC:self];
    self.filterSelectionView.x += 80;
    self.baseImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.tabArea addSubview:self.filterSelectionView];
    [self.view addSubview:self.sliderView];
    UIButton *cancelButton = [self makeCancelButton];
    UIButton *finishButton = [self makeFinishButton];
    self.navigationItem.leftBarButtonItem   = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:finishButton];
    self.title = @"フィルタ編集";
    if (self.filterContents) {
        [self filter];
    } else {
        self.filterContents = [[NSMutableDictionary alloc] init];
    }
}

- (void)loadedFilterView:(UIView *)filterView
{
    for (UIView *subview in self.sliderView.subviews) {
        [subview removeFromSuperview];
    }
    self.sliderView.frame = filterView.frame;
    [self.sliderView addSubview:filterView];
    self.sliderView.y = self.tabArea.y + self.tabArea.height;
    self.sliderView.hidden = NO;
    UIViewAnimationOptions animationOption = (UIViewAnimationOptions)UIViewAnimationCurveLinear;
    [UIView animateWithDuration:0.3f delay:0 options:animationOption animations:^{
        self.sliderView.y -= self.sliderView.height;
    } completion:nil];
}

- (void)closeFilterView
{
    UIViewAnimationOptions animationOption = (UIViewAnimationOptions)UIViewAnimationCurveLinear;
    [UIView animateWithDuration:0.3f delay:0 options:animationOption animations:^{
        self.sliderView.y = self.tabArea.y + self.tabArea.height;
    } completion:^(BOOL finished) {
        self.sliderView.hidden = NO;
    }];
}

- (void)filter
{
    @autoreleasepool {
        PhotoFilterProcessor *photoFilterProcessor = [PhotoFilterProcessor sharedInstance];
        UIImage *filteredImage = [photoFilterProcessor filterWithParam:self.filterContents
                                                        withInputImage:self.baseImage
                                                              withSize:PhotoFilterProcessorFilterFullScreenSize];
        self.baseImageView.image  = filteredImage;
        self.currentFilteredImage = filteredImage;
    }
}

- (void)changedParameterWithFilterName:(NSString *)filterName params:(id)filterParams
{
    if (filterName) {
        self.filterContents[filterName] = filterParams;
        if ([filterParams isKindOfClass:[NSDictionary class]] && ![[filterParams allKeys] count]) {
            [self.filterContents removeObjectForKey:filterName];
        } else if ([filterParams isKindOfClass:[NSArray class]] && ![filterParams count]) {
            [self.filterContents removeObjectForKey:filterName];
        }
        [self filter];
    }
}

- (UIButton *)makeCancelButton
{
    __weak EditFilterViewController *weakSelf = self;
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CLOSE_BUTTON_WIDTH, CLOSE_BUTTON_HEIGHT)];
    [cancelButton singleTap:^(UIGestureRecognizer *sender) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [cancelButton setTitle:@"キャンセル" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setContentEdgeInsets:UIEdgeInsetsMake(0.0f, -20.0f, 0.0f, 0.0f)];
    return cancelButton;
}

- (UIButton *)makeFinishButton
{
    __weak EditFilterViewController *weakSelf = self;
    UIButton *finishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, FINISH_BUTTON_WIDTH, FINISH_BUTTON_HEIGHT)];
    [finishButton singleTap:^(UIGestureRecognizer *sender) {
        UploadViewController *uploadVC = [[UploadViewController alloc] initWithNibName:@"UploadViewController" bundle:nil];
        uploadVC.filterContents = weakSelf.filterContents;
        uploadVC.inputImagePath = weakSelf.baseImagePath;
        uploadVC.filterName     = weakSelf.filterName;
        uploadVC.filteredImage  = weakSelf.currentFilteredImage;
        [weakSelf.navigationController pushViewController:uploadVC animated:YES];
    }];
    [finishButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    finishButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [finishButton setTitle:@"完了" forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [finishButton setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, -20.0f)];
    return finishButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)touchDownImageView:(id)sender
{
    self.baseImageView.image = self.baseImage;
}

- (IBAction)touchUpImageView:(id)sender
{
    if (!self.currentFilteredImage) return;
    self.baseImageView.image = self.currentFilteredImage;
}

- (IBAction)touchLoadImageButton:(id)sender
{
    SelectPhotoViewController *selectPhotoVC = [[SelectPhotoViewController alloc] initWithNibName:@"SelectPhotoViewController" bundle:nil];
    selectPhotoVC.loadedImage = ^(ALAsset *loadedImageAsset) {
        UIImage *loadedImage  = [loadedImageAsset fullResolutionImage];
        self.baseImagePath       = [loadedImageAsset imageBasePath];
        self.baseImageView.image = loadedImage;
        self.baseImage           = loadedImage;
        [self filter];
    };
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:selectPhotoVC];
    [self.navigationController presentViewController:naviVC animated:YES completion:nil];
}

@end
