//
//  CIGaussianGradientView.m
//  PhotoFilterProcessor
//
//  Created by goccy on 2014/09/27.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "CIGaussianGradientView.h"

@implementation CIGaussianGradientView

static NSString *FILTER_NAME = @"CIGaussianGradient";

- (id)initWithFrame:(CGRect)frame filterParams:(NSDictionary *)filterParams
{
    CIGaussianGradientView *loadedView = [[CIGaussianGradientView alloc] initWithNibName:@"CIGaussianGradientView"];
    self                  = [super initWithFrame:frame];
    self.frame            = loadedView.frame;
    self.backgroundColor  = [UIColor whiteColor];
    self.filterName       = FILTER_NAME;
    [self addSubview:loadedView];
    return self;
}


@end
