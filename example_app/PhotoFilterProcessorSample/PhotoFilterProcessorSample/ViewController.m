//
//  ViewController.m
//  PhotoFilterProcessorSample
//
//  Created by masaaki goshima on 2014/10/03.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "ViewController.h"
#import "PhotoFilterProcessor.h"

@interface ViewController ()

@property(nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *originalImage = [UIImage imageNamed:@"original.png"];
    UIImage *filteredImage = [[[PhotoFilterProcessor alloc] init] filterWithName:@"sample" withInputImage:originalImage];
    self.imageView.image   = filteredImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
