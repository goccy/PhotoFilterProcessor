//
//  CIUnsharpMaskView.m
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/26.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "CIUnsharpMaskView.h"

@implementation CIUnsharpMaskView

static NSString *FILTER_NAME = @"CIUnsharpMask";

- (id)initWithFrame:(CGRect)frame filterParams:(NSDictionary *)filterParams
{
    CIUnsharpMaskView *loadedView = [[CIUnsharpMaskView alloc] initWithNibName:@"CIUnsharpMaskView"];
    self                  = [super initWithFrame:loadedView.frame];
    self.radiusSlider     = loadedView.radiusSlider;
    self.intensitySlider  = loadedView.intensitySlider;
    self.filterName       = FILTER_NAME;
    
    [self setupSlider:self.radiusSlider withParamName:@"inputRadius" withFilterParam:filterParams];
    [self setupSlider:self.intensitySlider withParamName:@"inputIntensity" withFilterParam:filterParams];

    [self addSubview:loadedView];
    return self;
}

@end
