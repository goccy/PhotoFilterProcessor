//
//  CIUnsharpMaskView.h
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/26.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "FilterBaseView.h"

@interface CIUnsharpMaskView : FilterBaseView

@property(nonatomic, weak) IBOutlet UISlider *intensitySlider;
@property(nonatomic, weak) IBOutlet UISlider *radiusSlider;

- (id)initWithFrame:(CGRect)frame filterParams:(NSDictionary *)filterParams;

@end
