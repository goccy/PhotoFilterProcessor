//
//  CIOverlayBlendModeView.h
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/25.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "FilterBaseView.h"

@interface CIOverlayBlendModeView : FilterBaseView<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property(nonatomic, weak) IBOutlet UIButton *loadBlendImageButton;
@property(nonatomic) NSMutableArray *blendImages;

- (id)initWithFrame:(CGRect)frame filterParams:(NSArray *)filterParams;

@end
