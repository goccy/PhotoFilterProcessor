//
//  CIColorControlsView.m
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/25.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "CIColorControlsView.h"

@implementation CIColorControlsView

static NSString *FILTER_NAME = @"CIColorControls";

- (id)initWithFrame:(CGRect)frame filterParams:(NSDictionary *)filterParams
{
    CIColorControlsView *loadedView = [[CIColorControlsView alloc] initWithNibName:@"CIColorControlsView"];
    self                            = [super initWithFrame:loadedView.frame];
    self.contrastSlider             = loadedView.contrastSlider;
    self.saturationSlider           = loadedView.saturationSlider;
    self.brightnessSlider           = loadedView.brightnessSlider;
    self.filterName                 = FILTER_NAME;
    
    [self setupSlider:self.contrastSlider withParamName:@"inputContrast" withFilterParam:filterParams];
    [self setupSlider:self.saturationSlider withParamName:@"inputSaturation" withFilterParam:filterParams];
    [self setupSlider:self.brightnessSlider withParamName:@"inputBrightness" withFilterParam:filterParams];
    [self addSubview:loadedView];
    
    return self;
}

@end
