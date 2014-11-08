//
//  SelectPhotoViewController.m
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2013/12/11.
//  Copyright (c) 2013年 masaaki goshima. All rights reserved.
//

#import "SelectPhotoViewController.h"
#import "SelectPhotoViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageSelector.h"

@implementation SelectPhotoViewController

static const int CLOSE_BUTTON_WIDTH  = 80;
static const int CLOSE_BUTTON_HEIGHT = 40;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.photos = [NSMutableArray array];
        self.groups = [NSMutableArray array];
        __weak SelectPhotoViewController *weakSelf = self;
        self.library = [[ALAssetsLibrary alloc] init];
        //NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces;
        ALAssetsLibraryGroupsEnumerationResultsBlock groupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            if (!group) return;
            ALAssetsFilter *groupFilter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter: groupFilter];
            [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                if (!asset) return;
                UIImage *thumbnailImage = [UIImage imageWithCGImage:[asset thumbnail]];
                NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                            asset, @"asset", thumbnailImage, @"thumbnail", nil];
                [weakSelf.photos addObject:dictionary];
            }];
            [weakSelf.photos sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return NSOrderedDescending;
            }];
            [weakSelf.collectionView reloadData];
        };

        [self.library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:groupBlock failureBlock:^(NSError *error){
            NSLog(@"[ERROR]: %@", error);
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor backgroundThemeColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate   = self;
    [self.collectionView registerClass:[SelectPhotoViewCell class] forCellWithReuseIdentifier:@"Cell"];
    UIButton *cancelButton = [self makeCancelButton];
    self.navigationItem.leftBarButtonItem   = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.title = @"写真選択";
}

- (UIButton *)makeCancelButton
{
    __weak SelectPhotoViewController *weakSelf = self;
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CLOSE_BUTTON_WIDTH, CLOSE_BUTTON_HEIGHT)];
    [cancelButton singleTap:^(UIGestureRecognizer *sender) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [cancelButton setTitle:@"キャンセル" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setContentEdgeInsets:UIEdgeInsetsMake(0.0f, -20.0f, 0.0f, 0.0f)];
    return cancelButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SelectPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    for (UIView *subview in cell.subviews) {
        [subview removeFromSuperview];
    }
    NSDictionary *dictionary  = self.photos[indexPath.row];
    ALAsset *asset            = [dictionary objectForKey:@"asset"];
    cell.asset                = asset;
    UIImageView *thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.size.width, cell.size.height)];
    thumbnailImageView.contentMode  = UIViewContentModeScaleAspectFill;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage *thumbnailImage = [asset thumbnailImage];
        dispatch_async( dispatch_get_main_queue(), ^{
            thumbnailImageView.image = thumbnailImage;
        });
    });
    cell.thumbnailImageView = thumbnailImageView;
    [cell addSubview:thumbnailImageView];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary   = self.photos[indexPath.row];
    ALAsset *asset             = [dictionary objectForKey:@"asset"];
    [[ImageSelector alloc] saveImage:asset];
    if (self.loadedImage) self.loadedImage(asset);
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
