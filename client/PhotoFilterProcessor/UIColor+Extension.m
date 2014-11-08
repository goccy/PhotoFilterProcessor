//
//  UIColor+Extension.m
//  PhotoFilterProcessor
//
//  Created by goccy on 2014/09/27.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

static NSString *BACKGROUND_THEME_IMAGE_NAME = @"classy_fabric.png";
static NSString *TAB_THEME_IMAGE_NAME        = @"txture.png";

+ (UIColor *)backgroundThemeColor
{
    UIImage *backgroundImage = [UIImage imageNamed:BACKGROUND_THEME_IMAGE_NAME];
    return [UIColor colorWithPatternImage:backgroundImage];
}

+ (UIColor *)tabThemeColor
{
    UIImage *tabImage = [UIImage imageNamed:TAB_THEME_IMAGE_NAME];
    return [UIColor colorWithPatternImage:tabImage];
}

@end
