//
//  CIColorDodgeBlendModeView.h
//  PhotoFilterProcessor
//
//  Created by goccy on 2014/10/06.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "FilterBaseView.h"

@interface CIColorDodgeBlendModeView : FilterBaseView<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property(nonatomic, weak) IBOutlet UIButton *loadBlendImageButton;
@property(nonatomic) NSMutableArray *blendImages;

- (id)initWithFrame:(CGRect)frame filterParams:(NSArray *)filterParams;

@end
