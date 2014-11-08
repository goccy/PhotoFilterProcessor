//
//  FilterBaseView.m
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/25.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "FilterBaseView.h"
#import "EditFilterViewController.h"

@implementation FilterBaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.filterParams = [[NSMutableDictionary alloc] init];
    return self;
}

- (void)setupSlider:(UISlider *)slider withParamName:(NSString *)name withFilterParam:(NSDictionary *)filterParam
{
    NSDictionary *attributes   = [[CIFilter filterWithName:self.filterName] attributes];
    NSDictionary *defaultParam = attributes[name];
    
    slider.continuous   = NO;
    slider.maximumValue = [defaultParam[@"CIAttributeSliderMax"] floatValue];
    slider.minimumValue = [defaultParam[@"CIAttributeSliderMin"] floatValue];
    slider.value        = (filterParam[name])
    ? [filterParam[name] floatValue] : [defaultParam[@"CIAttributeDefault"] floatValue];
    [slider changed:^(UISlider *slider) {
        self.filterParams[name] = @(slider.value);
        [self filter];
    }];

    if (filterParam[name]) self.filterParams[name] = filterParam[name];
}

- (UIButton *)makeRemoveCurrentFilterButton
{
    static const int CLOSE_BUTTON_WIDTH = 80;
    UIButton *removeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, CLOSE_BUTTON_WIDTH, 40)];
    removeButton.layer.zPosition = 999;
    [removeButton setTitle:@"リセット" forState:UIControlStateNormal];
    removeButton.userInteractionEnabled = YES;
    [removeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [removeButton singleTap:^(UIGestureRecognizer *sender) {
        [self.filterParams removeAllObjects];
        [self filter];
    }];
    return removeButton;
}

- (UIButton *)makeCloseButton
{
    static const int CLOSE_BUTTON_WIDTH = 80;
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - CLOSE_BUTTON_WIDTH, 0, CLOSE_BUTTON_WIDTH, 40)];
    closeButton.layer.zPosition = 999;
    [closeButton setTitle:@"閉じる" forState:UIControlStateNormal];
    closeButton.userInteractionEnabled = YES;
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton singleTap:^(UIGestureRecognizer *sender) {
        [self close];
    }];
    return closeButton;
}

- (void)filter
{
    [self.editFilterVC changedParameterWithFilterName:self.filterName params:self.filterParams];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addSubview:[self makeCloseButton]];
    [self addSubview:[self makeRemoveCurrentFilterButton]];
    self.backgroundColor = [UIColor tabThemeColor];
}

- (void)close
{
    [self.editFilterVC closeFilterView];
}

@end