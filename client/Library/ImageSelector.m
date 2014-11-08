//
//  ImageSelector.m
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/29.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "ImageSelector.h"
#import "ALAsset+Cadenza.h"
#import "NSString+Cadenza.h"

@implementation ImageSelector

static NSString *IMAGE_SELECTOR_KEY = @"PhotoFilterProcessor_ImageSelector";

- (instancetype)init
{
    self = [super init];
    self.candidateResourceDirectoryPaths = [@[
        [[NSBundle mainBundle] resourcePath],
        [NSString applicationSupportDirectory]
    ] mutableCopy];
    return self;
}

- (UIImage *)loadThumbnailImageByImageBasePath:(NSString *)imageBasePath
{
    for (NSString *path in self.candidateResourceDirectoryPaths) {
        UIImage *loadedImage = [UIImage imageWithContentsOfFile:[ALAsset thumbnailImageSavePathWithDirectoryPath:path withBasePath:imageBasePath]];
        if (loadedImage) return loadedImage;
    }
    return nil;
}

- (UIImage *)loadFullScreenImageByImageBasePath:(NSString *)imageBasePath
{
    for (NSString *path in self.candidateResourceDirectoryPaths) {
        UIImage *loadedImage = [UIImage imageWithContentsOfFile:[ALAsset fullScreenImageSavePathWithDirectoryPath:path withBasePath:imageBasePath]];
        if (loadedImage) return loadedImage;
    }
    return nil;
}

- (UIImage *)loadFullResolutionImageByImageBasePath:(NSString *)imageBasePath
{
    for (NSString *path in self.candidateResourceDirectoryPaths) {
        UIImage *loadedImage = [UIImage imageWithContentsOfFile:[ALAsset fullResolutionImageSavePathWithDirectoryPath:path withBasePath:imageBasePath]];
        if (loadedImage) return loadedImage;
    }
    return nil;
}

- (NSDictionary *)loadImageByImageBasePath:(NSString *)imageBasePath
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault dictionaryForKey:IMAGE_SELECTOR_KEY][imageBasePath];
}

- (NSDictionary *)loadSavedAllImages
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault dictionaryForKey:IMAGE_SELECTOR_KEY];
}

- (void)saveImage:(ALAsset *)asset
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *images = [[userDefault dictionaryForKey:IMAGE_SELECTOR_KEY] mutableCopy];
    if (!images) images = [[NSMutableDictionary alloc] init];
    if (![asset saveAllImage]) {
        NSLog(@"[ERROR] : Cannot save image.");
        exit(EXIT_FAILURE);
    }
    images[[asset imageBasePath]] = @{
        @"thumbnailImagePath"      : [asset thumbnailImageSavePath],
        @"fullScreenImagePath"     : [asset fullScreenImageSavePath],
        @"fullResolutionImagePath" : [asset fullResolutionImageSavePath]
    };
    [userDefault setObject:images forKey:IMAGE_SELECTOR_KEY];
    [userDefault synchronize];
}

@end
