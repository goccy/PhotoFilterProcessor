//
//  FilterData.h
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/10/02.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterData : NSObject

@property(nonatomic) NSString *name;
@property(nonatomic) NSString *inputImagePath;
@property(nonatomic) NSDictionary *body;
@property(nonatomic) NSDate   *updatedAt;
@property(nonatomic) NSDate   *createdAt;

- (UIImage *)inputImage;
- (NSString *)serializedBody;

@end
