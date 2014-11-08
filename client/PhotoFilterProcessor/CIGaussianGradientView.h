//
//  CIGaussianGradientView.h
//  PhotoFilterProcessor
//
//  Created by goccy on 2014/09/27.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "FilterBaseView.h"

@interface CIGaussianGradientView : FilterBaseView

@property(nonatomic, weak) IBOutlet UIView *editView;

- (id)initWithFrame:(CGRect)frame filterParams:(NSDictionary *)filterParams;

@end
