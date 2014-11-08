//
//  CIColorMatrixView.h
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/26.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "FilterBaseView.h"

@interface CIColorMatrixView : FilterBaseView

@property(nonatomic, weak) IBOutlet UISlider *redSlider;
@property(nonatomic, weak) IBOutlet UISlider *greenSlider;
@property(nonatomic, weak) IBOutlet UISlider *blueSlider;
@property(nonatomic, weak) IBOutlet UISlider *alphaSlider;

- (id)initWithFrame:(CGRect)frame filterParams:(NSDictionary *)filterParams;

@end
