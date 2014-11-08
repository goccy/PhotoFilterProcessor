//
//  ImageSelector.h
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/29.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ImageSelector : NSObject

@property(nonatomic) NSMutableArray *candidateResourceDirectoryPaths;

- (UIImage *)loadThumbnailImageByImageBasePath:(NSString *)imageBasePath;
- (UIImage *)loadFullScreenImageByImageBasePath:(NSString *)imageBasePath;
- (UIImage *)loadFullResolutionImageByImageBasePath:(NSString *)imageBasePath;
- (NSDictionary *)loadImageByImageBasePath:(NSString *)imageBasePath;
- (NSDictionary *)loadSavedAllImages;
- (void)saveImage:(ALAsset *)asset;

@end
