//
//  CIColorMonochromeView.m
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/25.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "CIColorMonochromeView.h"

@implementation CIColorMonochromeView

static NSString *CELL_IDENTIFIER = @"CELL";
static NSString *FILTER_NAME     = @"CIColorMonochrome";

- (id)initWithFrame:(CGRect)frame filterParams:(NSDictionary *)filterParams
{
    CIColorMonochromeView *loadedView = [[CIColorMonochromeView alloc] initWithNibName:@"CIColorMonochromeView"];
    self = [super initWithFrame:loadedView.frame];
    self.collectionView   = loadedView.collectionView;
    self.intensitySlider  = loadedView.intensitySlider;
    self.filterName = FILTER_NAME;
    
    [self setupSlider:self.intensitySlider withParamName:@"inputIntensity" withFilterParam:filterParams];
    if (filterParams[@"inputColor"]) self.filterParams[@"inputColor"] = filterParams[@"inputColor"];

    [self addSubview:loadedView];
    self.simpleColors = @[
        [UIColor whiteColor],
        [UIColor blackColor],
        [UIColor redColor],
        [UIColor greenColor],
        [UIColor blueColor],
        [UIColor yellowColor],
        [UIColor cyanColor],
        [UIColor magentaColor],
        [UIColor orangeColor],
        [UIColor brownColor],
        [UIColor grayColor]
    ];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    self.collectionView.delegate   = self;
    self.collectionView.dataSource = self;
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.backgroundColor = [UIColor tabThemeColor];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.simpleColors count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    cell.backgroundColor = self.simpleColors[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *color = self.simpleColors[indexPath.row];
    self.filterParams[@"inputColor"] = [color hexString];
    [self filter];
}

@end
