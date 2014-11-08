//
//  CIExposureAdjustView.m
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/26.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "CIExposureAdjustView.h"

@implementation CIExposureAdjustView

static NSString *FILTER_NAME = @"CIExposureAdjust";

- (id)initWithFrame:(CGRect)frame filterParams:(NSDictionary *)filterParams
{
    CIExposureAdjustView *loadedView = [[CIExposureAdjustView alloc] initWithNibName:@"CIExposureAdjustView"];
    self                             = [super initWithFrame:loadedView.frame];
    self.evSlider                    = loadedView.evSlider;
    self.filterName                  = FILTER_NAME;
    
    [self setupSlider:self.evSlider withParamName:@"inputEV" withFilterParam:filterParams];
    [self addSubview:loadedView];
    return self;
}

@end
