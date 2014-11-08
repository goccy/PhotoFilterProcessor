//
//  CIColorMonochromeView.h
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/25.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterBaseView.h"

@interface CIColorMonochromeView : FilterBaseView<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property(nonatomic, weak) IBOutlet UISlider *intensitySlider;
@property(nonatomic) NSArray *simpleColors;

- (id)initWithFrame:(CGRect)frame filterParams:(NSDictionary *)filterParams;

@end
