//
//  SelectPhotoViewCell.m
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2013/12/11.
//  Copyright (c) 2013年 masaaki goshima. All rights reserved.
//

#import "SelectPhotoViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation SelectPhotoViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.thumbnailImageView.userInteractionEnabled = YES;
    return self;
}

@end
