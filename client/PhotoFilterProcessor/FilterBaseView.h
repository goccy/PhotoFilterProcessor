//
//  FilterBaseView.h
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/25.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditFilterViewController;

@interface FilterBaseView : UIView

@property(nonatomic) EditFilterViewController *editFilterVC;
@property(nonatomic) NSString *filterName;
@property(nonatomic) NSMutableDictionary *filterParams;
@property(nonatomic) UIButton *closeButton;

- (void)filter;
- (void)setupSlider:(UISlider *)slider withParamName:(NSString *)name withFilterParam:(NSDictionary *)filterParam;

@end
