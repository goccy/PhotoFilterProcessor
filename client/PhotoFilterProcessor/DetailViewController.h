//
//  DetailViewController.h
//  PhotoFilterProcessor
//
//  Created by 五嶋 壮晃 on 2014/09/24.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

