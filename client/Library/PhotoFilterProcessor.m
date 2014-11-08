//
//  PhotoFilterProcessor.m
//  PhotoFilterProcessorSample
//
//  Created by masaaki goshima on 2014/10/03.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "PhotoFilterProcessor.h"
#import "ImageSelector.h"
#import "Cadenza.h"

@implementation PhotoFilterProcessor

static const NSInteger CROP_NUMBER = 4;
static const NSInteger LARGE_IMAGE_THRESHOLD = 1024 * 1024;

PhotoFilterProcessor *sharedInstance;

+ (instancetype)sharedInstance
{
    if (sharedInstance) return sharedInstance;
    sharedInstance = [[PhotoFilterProcessor alloc] init];
    sharedInstance.candidateResourceDirectoryPaths = [@[ [[NSBundle mainBundle] resourcePath] ] mutableCopy];
    return sharedInstance;
}

- (void)addCandidateResourceDirectoryPath:(NSString *)candidateDirectoryPath
{
    if (!self.candidateResourceDirectoryPaths) {
        self.candidateResourceDirectoryPaths = [@[ [[NSBundle mainBundle] resourcePath] ] mutableCopy];
    }
    [self.candidateResourceDirectoryPaths addObject:candidateDirectoryPath];
}

- (void)addCandidateResourceDirectoryPathWithArray:(NSArray *)candidateDirectoryPaths
{
    if (!self.candidateResourceDirectoryPaths) {
        self.candidateResourceDirectoryPaths = [@[ [[NSBundle mainBundle] resourcePath] ] mutableCopy];
    }
    [self.candidateResourceDirectoryPaths addObjectsFromArray:candidateDirectoryPaths];
}

- (NSDictionary *)loadJson:(NSString *)jsonPath
{
    NSError *error = nil;
    NSString *mainBundlePath = [[NSBundle mainBundle] resourcePath];
    NSData *jsonData         = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", mainBundlePath, jsonPath]];
    if (!jsonData) {
        for (NSString *path in self.candidateResourceDirectoryPaths) {
            jsonData = [NSData dataWithContentsOfFile:path];
            if (jsonData) break;
        }
    }
    NSDictionary *ret = (jsonData) ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error] : @{};
    if (error) {
        NSLog(@"[ERROR] : Cannot load json. [%@]", error);
    }
    return ret;
}

- (UIImage *)loadImage:(NSString *)path withFilterSize:(PhotoFilterProcessorFilterSize)filterSize
{
    UIImage *ret = nil;
    switch (filterSize) {
        case PhotoFilterProcessorFilterThumbnailSize:
            ret = [[[ImageSelector alloc] init] loadThumbnailImageByImageBasePath:path];
            break;
        case PhotoFilterProcessorFilterFullScreenSize:
            ret = [[[ImageSelector alloc] init] loadFullScreenImageByImageBasePath:path];
            break;
        case PhotoFilterProcessorFilterFullResolutionSize:
            ret = [[[ImageSelector alloc] init] loadFullResolutionImageByImageBasePath:path];
            break;
        default:
            break;
    }
    return ret;
}

- (CIImage *)filter:(NSString *)filterName
        withCIImage:(CIImage *)inputCIImage
          withParam:(NSMutableDictionary *)param
           withSize:(PhotoFilterProcessorFilterSize)filterSize
withHookBackgroundBlendImageAfterLoaded:(UIImage *(^)(UIImage *))callback
       withCropRect:(CGRect)cropRect
{
    CIFilter *filter     = [CIFilter filterWithName:filterName];
    [filter setDefaults];
    NSDictionary *filterAttributes = [filter attributes];
    for (NSString *attributeKey in [filterAttributes allKeys]) {
        @autoreleasepool {
            if ([attributeKey isEqualToString:@"inputImage"]) {
                [filter setValue:inputCIImage forKey:attributeKey];
                continue;
            } else if ([attributeKey isEqualToString:@"inputBackgroundImage"]) {
                NSString *backgroundImagePath     = param[attributeKey];
                UIImage *backgroundImage          = [self loadImage:backgroundImagePath withFilterSize:filterSize];
                if (cropRect.size.width == 0 || cropRect.size.height == 0) {
                    UIImage *resizedBackgroundImage   = [backgroundImage resizeImageWithSize:inputCIImage.extent.size];
                    if (callback) {
                        resizedBackgroundImage = callback(resizedBackgroundImage);
                    }
                    CIImage *resizedBackgroundCIImage = [CIImage imageWithCGImage:resizedBackgroundImage.CGImage];
                    [filter setValue:resizedBackgroundCIImage forKey:attributeKey];
                } else {
                    UIImage *resizedBackgroundImage;
                    if ([param[@"inputBackgroundImage"] isKindOfClass:[UIImage class]]) {
                        resizedBackgroundImage = param[@"inputBackgroundImage"];
                    } else {
                        resizedBackgroundImage = [backgroundImage resizeImageWithSize:CGSizeMake(cropRect.size.width * 2, cropRect.size.height * 2)];
                        if (callback) {
                            resizedBackgroundImage = callback(resizedBackgroundImage);
                        }
                        param[@"inputBackgroundImage"] = resizedBackgroundImage;
                    }
                    UIImage *cropedImage = [self cropImage:resizedBackgroundImage rect:cropRect];
                    CIImage *resizedBackgroundCIImage = [CIImage imageWithCGImage:cropedImage.CGImage];
                    [filter setValue:resizedBackgroundCIImage forKey:attributeKey];
                }
                continue;
            } else if ([attributeKey isEqualToString:@"inputColor"]) {
                NSString *colorString = param[attributeKey];
                UIColor *color        = [UIColor colorWithHexString:colorString alpha:1.0f];
                [filter setValue:[CIColor colorWithCGColor:color.CGColor] forKey:attributeKey];
                continue;
            } else if ([attributeKey rangeOfString:@"Vector"].location != NSNotFound) {
                NSString *vectorString = param[attributeKey];
                CIVector *vector       = [CIVector vectorWithString:vectorString];
                [filter setValue:vector forKey:attributeKey];
                continue;
            }
            id attributeValue = param[attributeKey];
            if (attributeValue) {
                [filter setValue:attributeValue forKey:attributeKey];
            }
        }
    }
    return filter.outputImage;
}

- (UIImage *)filterWithName:(NSString *)filterName withInputImage:(UIImage *)inputImage
{
    return [self filterWithName:filterName withInputImage:inputImage withSize:PhotoFilterProcessorFilterFullResolutionSize];
}

- (UIImage *)filterWithName:(NSString *)filterName withInputImage:(UIImage *)inputImage withSize:(PhotoFilterProcessorFilterSize)filterSize
{
    return [self filterWithName:filterName withInputImage:inputImage withSize:filterSize withHookBackgroundBlendImageAfterLoaded:nil];
}

- (UIImage *)filterWithName:(NSString *)filterName
             withInputImage:(UIImage *)inputImage
                   withSize:(PhotoFilterProcessorFilterSize)filterSize
withHookBackgroundBlendImageAfterLoaded:(UIImage *(^)(UIImage *))callback
{
    NSMutableDictionary *filterParam = [[self loadJson:[NSString stringWithFormat:@"%@-filter.json", filterName]] mutableCopy];
    return [self filterWithParam:filterParam withInputImage:inputImage withSize:filterSize withHookBackgroundBlendImageAfterLoaded:callback];
}

- (UIImage*)cropImage:(UIImage*)image rect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *result     = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return result;
}

- (UIImage *)filterWithCropedAlgorithm:(NSMutableDictionary *)filterParam
withHookBackgroundBlendImageAfterLoaded:(UIImage *(^)(UIImage *))callback
                        withInputImage:(UIImage *)inputImage
{
    assert(CROP_NUMBER % 2 == 0 && "[ERROR] : CROP_NUMBER must be even number");
    size_t divNumber = CROP_NUMBER / 2;
    CGSize size = inputImage.size;
    CGFloat width  = size.width;
    CGFloat height = size.height;
    
    inputImage  = [inputImage fixOrientation];
    NSMutableDictionary *mutableFilterParam = [filterParam mutableCopy];
    UIGraphicsBeginImageContext(size);
    for (size_t y = 0; y < divNumber; y++) {
        for (size_t x = 0; x < divNumber; x++) {
            @autoreleasepool {
                CGFloat divFloatNumber = (CGFloat)divNumber;
                CGRect rect = CGRectMake(x * width / divFloatNumber, y * height / divFloatNumber, width / divFloatNumber, height / divFloatNumber);
                UIImage *cropedImage  = [self cropImage:inputImage rect:rect];
                CIImage *inputCIImage = [[CIImage alloc] initWithCGImage:cropedImage.CGImage];
                UIImage *outputImage  = [self filterWithParam:mutableFilterParam
                                             withInputCIImage:inputCIImage
                                                     withSize:PhotoFilterProcessorFilterFullResolutionSize
                                         withHookBackgroundBlendImageAfterLoaded:callback
                                                 withCropRect:rect];
                [outputImage drawInRect:rect];
            }
        }
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

- (UIImage *)filterWithParam:(NSMutableDictionary *)filterParam
            withInputCIImage:(CIImage *)inputCIImage
                    withSize:(PhotoFilterProcessorFilterSize)filterSize
withHookBackgroundBlendImageAfterLoaded:(UIImage *(^)(UIImage *))callback
                withCropRect:(CGRect)cropRect
{
    for (NSString *ciFilterName in [filterParam allKeys]) {
        id params = filterParam[ciFilterName];
        if ([params isKindOfClass:[NSArray class]]) {
            NSMutableArray *newParams = [@[] mutableCopy];
            for (NSDictionary *param in params) {
                NSMutableDictionary *mutableParam = [param mutableCopy];
                inputCIImage = [self filter:ciFilterName
                                withCIImage:inputCIImage
                                  withParam:mutableParam
                                   withSize:filterSize
    withHookBackgroundBlendImageAfterLoaded:callback
                               withCropRect:cropRect];
                [newParams addObject:mutableParam];
            }
            filterParam[ciFilterName] = newParams;
        } else {
            NSMutableDictionary *mutableParam = [params mutableCopy];
            inputCIImage = [self filter:ciFilterName
                            withCIImage:inputCIImage
                              withParam:mutableParam
                               withSize:filterSize
withHookBackgroundBlendImageAfterLoaded:callback
                           withCropRect:cropRect];
            filterParam[ciFilterName] = mutableParam;
        }
    }
    if (!self.renderContext) self.renderContext = [CIContext contextWithOptions:nil];
    CGImageRef imageRef  = [self.renderContext createCGImage:inputCIImage fromRect:[inputCIImage extent]];
    UIImage *outputImage = [UIImage imageWithCGImage:imageRef scale:1.0f orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    return outputImage;
}

- (UIImage *)filterWithParam:(NSMutableDictionary *)filterParam withInputImage:(UIImage *)inputImage withSize:(PhotoFilterProcessorFilterSize)filterSize
{
    return [self filterWithParam:filterParam withInputImage:inputImage withSize:filterSize withHookBackgroundBlendImageAfterLoaded:nil];
}

- (UIImage *)filterWithParam:(NSMutableDictionary *)filterParam
              withInputImage:(UIImage *)inputImage
                    withSize:(PhotoFilterProcessorFilterSize)filterSize
withHookBackgroundBlendImageAfterLoaded:(UIImage *(^)(UIImage *))callback
{
    UIImage *outputImage;
    BOOL isResolvedUnsharpMaskBug = NO;
    @autoreleasepool {
        if (isResolvedUnsharpMaskBug && inputImage.size.width * inputImage.size.height > LARGE_IMAGE_THRESHOLD) {
            outputImage = [self filterWithCropedAlgorithm:filterParam
                  withHookBackgroundBlendImageAfterLoaded:callback
                                           withInputImage:inputImage];
         } else {
            CIImage *inputCIImage = [[CIImage alloc] initWithCGImage:[inputImage fixOrientation].CGImage];
            outputImage = [self filterWithParam:filterParam
                               withInputCIImage:inputCIImage
                                       withSize:filterSize
        withHookBackgroundBlendImageAfterLoaded:callback
                                   withCropRect:CGRectZero];
        }
    }
    return outputImage;
}

- (NSArray *)filterNames
{
    NSMutableArray *filterNames = [[NSMutableArray alloc] init];
    if (!self.candidateResourceDirectoryPaths) {
        self.candidateResourceDirectoryPaths = [@[ [[NSBundle mainBundle] resourcePath] ] mutableCopy];
    }
    NSFileManager *manager = NSFileManager.defaultManager;
    NSMutableArray *paths  = self.candidateResourceDirectoryPaths;
    for (NSString *path in paths) {
        if (!path) continue;
        NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:path];
        for (NSString *filename in fileEnumerator) {
            if ([filename hasSuffix:@"-filter.json"]) {
                NSString *filterName = [filename componentsSeparatedByString:@"-filter.json"][0];
                [filterNames addObject:filterName];
            }
        }
    }
    return filterNames;
}

@end
