//
//  CIColorMatrixView.m
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/26.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "CIColorMatrixView.h"

@implementation CIColorMatrixView

static NSString *FILTER_NAME = @"CIColorMatrix";

- (id)initWithFrame:(CGRect)frame filterParams:(NSDictionary *)filterParams
{
    CIColorMatrixView *loadedView = [[CIColorMatrixView alloc] initWithNibName:@"CIColorMatrixView"];
    self = [super initWithFrame:loadedView.frame];
    self.redSlider   = loadedView.redSlider;
    self.greenSlider = loadedView.greenSlider;
    self.blueSlider  = loadedView.blueSlider;
    self.alphaSlider = loadedView.alphaSlider;
    [self addSubview:loadedView];
    
    self.filterName = FILTER_NAME;
    CIFilter *filter = [CIFilter filterWithName:FILTER_NAME];
    NSDictionary *attributes = [filter attributes];
    
    self.redSlider.continuous   = NO;
    self.redSlider.maximumValue = 1.0f;
    self.redSlider.minimumValue = 0.0f;

    CIVector *rVector;
    if (filterParams[@"inputRVector"]) {
        rVector = [CIVector vectorWithString:filterParams[@"inputRVector"]];
    } else {
        NSDictionary *rVectorParam = attributes[@"inputRVector"];
        rVector = rVectorParam[@"CIAttributeDefault"];
        self.filterParams[@"inputRVector"] = [rVector stringRepresentation];
    }
    self.redSlider.value = rVector.X;
    [self.redSlider addTarget:self action:@selector(changedRed:) forControlEvents:UIControlEventValueChanged];
    
    self.greenSlider.continuous   = NO;
    self.greenSlider.maximumValue = 1.0f;
    self.greenSlider.minimumValue = 0.0f;
    
    CIVector *gVector;
    if (filterParams[@"inputGVector"]) {
        gVector = [CIVector vectorWithString:filterParams[@"inputGVector"]];
    } else {
        NSDictionary *rVectorParam = attributes[@"inputGVector"];
        gVector = rVectorParam[@"CIAttributeDefault"];
        self.filterParams[@"inputGVector"] = [gVector stringRepresentation];
    }
    self.greenSlider.value = gVector.Y;
    [self.greenSlider addTarget:self action:@selector(changedGreen:) forControlEvents:UIControlEventValueChanged];
    
    self.blueSlider.continuous   = NO;
    self.blueSlider.maximumValue = 1.0f;
    self.blueSlider.minimumValue = 0.0f;

    CIVector *bVector;
    if (filterParams[@"inputBVector"]) {
        bVector = [CIVector vectorWithString:filterParams[@"inputBVector"]];
    } else {
        NSDictionary *bVectorParam = attributes[@"inputBVector"];
        bVector = bVectorParam[@"CIAttributeDefault"];
        self.filterParams[@"inputBVector"] = [bVector stringRepresentation];
    }
    self.blueSlider.value = bVector.Z;
    [self.blueSlider addTarget:self action:@selector(changedBlue:) forControlEvents:UIControlEventValueChanged];
    
    self.alphaSlider.continuous   = NO;
    self.alphaSlider.maximumValue = 1.0f;
    self.alphaSlider.minimumValue = 0.0f;
    
    CIVector *aVector;
    if (filterParams[@"inputAVector"]) {
        aVector = [CIVector vectorWithString:filterParams[@"inputAVector"]];
    } else {
        NSDictionary *aVectorParam = attributes[@"inputAVector"];
        aVector = aVectorParam[@"CIAttributeDefault"];
        self.filterParams[@"inputAVector"] = [aVector stringRepresentation];
    }
    self.alphaSlider.value = aVector.W;
    [self.alphaSlider addTarget:self action:@selector(changedAlpha:) forControlEvents:UIControlEventValueChanged];

    if (filterParams[@"inputRVector"]) self.filterParams[@"inputRVector"] = filterParams[@"inputRVector"];
    if (filterParams[@"inputGVector"]) self.filterParams[@"inputGVector"] = filterParams[@"inputGVector"];
    if (filterParams[@"inputBVector"]) self.filterParams[@"inputBVector"] = filterParams[@"inputBVector"];
    if (filterParams[@"inputAVector"]) self.filterParams[@"inputAVector"] = filterParams[@"inputAVector"];
    return self;
}

- (void)changedRed:(UISlider *)slider
{
    CGFloat red = slider.value;
    self.filterParams[@"inputRVector"] = [[CIVector vectorWithX:red Y:0 Z:0 W:0] stringRepresentation];
    [self filter];
}

- (void)changedGreen:(UISlider *)slider
{
    CGFloat green = slider.value;
    self.filterParams[@"inputGVector"] = [[CIVector vectorWithX:0 Y:green Z:0 W:0] stringRepresentation];
    [self filter];
}

- (void)changedBlue:(UISlider *)slider
{
    CGFloat blue = slider.value;
    self.filterParams[@"inputBVector"] = [[CIVector vectorWithX:0 Y:0 Z:blue W:0] stringRepresentation];
    [self filter];
}

- (void)changedAlpha:(UISlider *)slider
{
    CGFloat alpha = slider.value;
    self.filterParams[@"inputAVector"] = [[CIVector vectorWithX:0 Y:0 Z:0 W:alpha] stringRepresentation];
    [self filter];
}

@end
