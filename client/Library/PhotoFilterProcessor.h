//
//  PhotoFilterProcessor.h
//  PhotoFilterProcessorSample
//
//  Created by masaaki goshima on 2014/10/03.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    PhotoFilterProcessorFilterThumbnailSize,
    PhotoFilterProcessorFilterFullScreenSize,
    PhotoFilterProcessorFilterFullResolutionSize,
} PhotoFilterProcessorFilterSize;

@interface PhotoFilterProcessor : NSObject

@property(nonatomic) CIContext *renderContext;
@property(nonatomic) NSMutableArray *candidateResourceDirectoryPaths;

+ (instancetype)sharedInstance;
- (void)addCandidateResourceDirectoryPath:(NSString *)candidateDirectoryPath;
- (void)addCandidateResourceDirectoryPathWithArray:(NSArray *)candidateDirectoryPaths;
- (UIImage *)filterWithName:(NSString *)filterName withInputImage:(UIImage *)inputImage;
- (UIImage *)filterWithName:(NSString *)filterName withInputImage:(UIImage *)inputImage withSize:(PhotoFilterProcessorFilterSize)filterSize;

- (UIImage *)filterWithName:(NSString *)filterName
             withInputImage:(UIImage *)inputImage
                   withSize:(PhotoFilterProcessorFilterSize)filterSize
withHookBackgroundBlendImageAfterLoaded:(UIImage *(^)(UIImage *))callback;

- (UIImage *)filterWithParam:(NSDictionary *)filterParam withInputImage:(UIImage *)inputImage withSize:(PhotoFilterProcessorFilterSize)filterSize;
- (NSArray *)filterNames;

@end
