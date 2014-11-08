//
//  CIColorControlsView.h
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/25.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterBaseView.h"

@interface CIColorControlsView : FilterBaseView

@property(nonatomic) EditFilterViewController *editFilterVC;
@property(nonatomic, weak) IBOutlet UISlider *contrastSlider;
@property(nonatomic, weak) IBOutlet UISlider *saturationSlider;
@property(nonatomic, weak) IBOutlet UISlider *brightnessSlider;

- (id)initWithFrame:(CGRect)frame filterParams:(NSDictionary *)filterParams;

@end
