//
//  CIHueAdjustView.m
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/26.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "CIHueAdjustView.h"

@implementation CIHueAdjustView

static NSString *FILTER_NAME = @"CIHueAdjust";

- (id)initWithFrame:(CGRect)frame filterParams:(NSDictionary *)filterParams
{
    CIHueAdjustView *loadedView = [[CIHueAdjustView alloc] initWithNibName:@"CIHueAdjustView"];
    self                        = [super initWithFrame:loadedView.frame];
    self.angleSlider            = loadedView.angleSlider;
    self.filterName             = FILTER_NAME;
    
    [self setupSlider:self.angleSlider withParamName:@"inputAngle" withFilterParam:filterParams];
    [self addSubview:loadedView];
    return self;
}

@end
