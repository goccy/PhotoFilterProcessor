//
//  CISepiaToneView.h
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/26.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "FilterBaseView.h"

@interface CISepiaToneView : FilterBaseView

@property(nonatomic, weak) IBOutlet UISlider *intensitySlider;

- (id)initWithFrame:(CGRect)frame filterParams:(NSDictionary *)filterParams;

@end
