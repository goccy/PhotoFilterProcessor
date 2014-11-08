//
//  CISepiaToneView.m
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/26.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "CISepiaToneView.h"

@implementation CISepiaToneView

static NSString *FILTER_NAME     = @"CISepiaTone";

- (id)initWithFrame:(CGRect)frame filterParams:(NSDictionary *)filterParams
{
    CISepiaToneView *loadedView = [[CISepiaToneView alloc] initWithNibName:@"CISepiaToneView"];
    self                        = [super initWithFrame:loadedView.frame];
    self.intensitySlider        = loadedView.intensitySlider;
    self.filterName             = FILTER_NAME;
    
    [self setupSlider:self.intensitySlider withParamName:@"inputIntensity" withFilterParam:filterParams];
    [self addSubview:loadedView];
    return self;
}

@end
