//
//  FilterData.m
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/10/02.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "FilterData.h"
#import "ImageSelector.h"

@implementation FilterData

- (UIImage *)inputImage
{
    return [[[ImageSelector alloc] init] loadFullScreenImageByImageBasePath:self.inputImagePath];
}

- (NSString *)serializedBody
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.body options:2 error:&error];
    if (error) NSLog(@"json serialize error: %@", error);
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
