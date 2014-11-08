//
//  CIGaussianBlurView.m
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/26.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "CIGaussianBlurView.h"

@implementation CIGaussianBlurView

static NSString *FILTER_NAME     = @"CIGaussianBlur";

- (id)initWithFrame:(CGRect)frame filterParams:(NSDictionary *)filterParams
{
    CIGaussianBlurView *loadedView = [[CIGaussianBlurView alloc] initWithNibName:@"CIGaussianBlurView"];
    self                           = [super initWithFrame:loadedView.frame];
    self.radiusSlider              = loadedView.radiusSlider;
    self.filterName                = FILTER_NAME;
    
    [self setupSlider:self.radiusSlider withParamName:@"inputRadius" withFilterParam:filterParams];
    [self addSubview:loadedView];
    return self;
}

@end
