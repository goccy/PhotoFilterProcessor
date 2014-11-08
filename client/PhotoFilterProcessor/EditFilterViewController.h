//
//  EditFilterViewController.h
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/24.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditFilterViewController : UIViewController

@property(nonatomic) NSString *baseImagePath;
@property(nonatomic) UIImage *baseImage;
@property(nonatomic) UIImage *currentFilteredImage;
@property(nonatomic, weak) IBOutlet UIImageView *baseImageView;
@property(nonatomic, weak) IBOutlet UIView *tabArea;
@property(nonatomic, weak) IBOutlet UIButton *loadImageButton;

@property(nonatomic) NSString *filterName;
@property(nonatomic) NSMutableDictionary *filterContents;
@property(nonatomic) CIContext *renderContext;
@property(nonatomic) UIView *sliderView;
@property(nonatomic) UIImageOrientation currentImageOrientation;

- (void)loadedFilterView:(UIView *)filterView;
- (void)changedParameterWithFilterName:(NSString *)filterName params:(id)filterParams;
- (void)closeFilterView;

@end
