//
//  UploadViewController.m
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/29.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "UploadViewController.h"
#import "FilterDataManager.h"
#import "FilterData.h"
#import <SSZipArchive/SSZipArchive.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/AFNetworking.h>

@interface UploadViewController ()

@end

@implementation UploadViewController

static NSString *CELL_IDENTIFIER = @"FILTER_TABLE_CELL";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"アップロード";
    self.inputFilterNameField.text = self.filterName;
    self.inputFilterNameField.textAlignment = NSTextAlignmentCenter;
    self.inputFilterNameField.returnKeyType = UIReturnKeyDone;
    self.inputFilterNameField.delegate = self;
    [self.usedFilterListView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    self.view.backgroundColor = [UIColor backgroundThemeColor];
    self.usedFilterNames = [self.filterContents allKeys];
    self.usedFilterListView.dataSource = self;
    self.usedFilterListView.delegate   = self;
    [self.usedFilterListView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.usedFilterNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell    = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    NSString *usedFilterName = self.usedFilterNames[indexPath.row];
    cell.textLabel.text      = usedFilterName;
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *)getFilterName
{
    return self.inputFilterNameField.text;
}

- (BOOL)canSave:(NSString *)filterName
{
    return ([filterName length] > 0) ? YES : NO;
}

- (BOOL)validateFilterName
{
    if (![self canSave:[self getFilterName]]) {
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.title   = @"エラー";
        alert.message = @"フィルタ名を入力してください";
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        return NO;
    }
    return YES;
}

- (void)saveFilterContents
{
    FilterDataManager *filterDataManager = [[FilterDataManager alloc] init];
    [filterDataManager saveFilterDataWithName:[self getFilterName] withInputImagePath:self.inputImagePath withData:self.filterContents];
}

- (NSArray *)partBackgroundImagePaths:(NSDictionary *)filterParam
{
    NSMutableArray *backgroundImagePaths = [[NSMutableArray alloc] init];
    for (NSString *attributeKey in [filterParam allKeys]) {
        if ([attributeKey isEqualToString:@"inputBackgroundImage"]) {
            NSString *backgroundImagePath = filterParam[attributeKey];
            [backgroundImagePaths addObject:[ALAsset thumbnailImageSavePathWithBasePath:backgroundImagePath]];
            [backgroundImagePaths addObject:[ALAsset fullScreenImageSavePathWithBasePath:backgroundImagePath]];
            [backgroundImagePaths addObject:[ALAsset fullResolutionImageSavePathWithBasePath:backgroundImagePath]];
        }
    }
    return backgroundImagePaths;
}

- (NSArray *)backgroundImagePaths:(NSDictionary *)filterParams
{
    NSMutableArray *backgroundImagePaths = [[NSMutableArray alloc] init];
    for (NSString *filterName in [filterParams allKeys]) {
        id params = filterParams[filterName];
        if ([params isKindOfClass:[NSMutableArray class]]) {
            for (NSDictionary *param in params) {
                [backgroundImagePaths addObjectsFromArray:[self partBackgroundImagePaths:param]];
            }
        } else {
            [backgroundImagePaths addObjectsFromArray:[self partBackgroundImagePaths:params]];
        }
    }
    return backgroundImagePaths;
}

- (void)uploadFilter
{
    [SVProgressHUD show];
    FilterData *filterData = [[[FilterDataManager alloc] init] getFilterDataWithName:[self getFilterName]];
    NSString *name         = filterData.name;
    NSString *body         = [filterData serializedBody];
    NSError *error         = nil;
    NSString *encodedName  = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonFilePath = [NSString stringWithFormat:@"%@/%@-filter.json", [NSString applicationSupportDirectory], encodedName];
    NSString *filteredImagePath = [NSString stringWithFormat:@"%@/%@-filtered-image.jpg", [NSString applicationSupportDirectory], encodedName];
    [body writeToFile:jsonFilePath atomically:NO encoding:NSUTF8StringEncoding error:&error];
    [UIImageJPEGRepresentation(self.filteredImage, 1.0f) writeToFile:filteredImagePath atomically:NO];
    NSString *zipName      = [NSString stringWithFormat:@"%@-filter.zip", name];
    NSString *zippedPath   = [NSString stringWithFormat:@"%@/%@", [NSString applicationSupportDirectory], zipName];
    NSArray *backgroundImagePaths = [self backgroundImagePaths:filterData.body];
    
    NSMutableArray *contentsPaths = [@[
        [ALAsset thumbnailImageSavePathWithBasePath:self.inputImagePath],
        [ALAsset fullScreenImageSavePathWithBasePath:self.inputImagePath],
        [ALAsset fullResolutionImageSavePathWithBasePath:self.inputImagePath],
        jsonFilePath,
        filteredImagePath
    ] mutableCopy];
    [contentsPaths addObjectsFromArray: backgroundImagePaths];
    [SSZipArchive createZipFileAtPath:zippedPath withFilesAtPaths:contentsPaths];
    NSData *zipData = [NSData dataWithContentsOfFile:zippedPath];
    NSString *url = [NSString stringWithFormat:@"http://%@:%@/upload_filter", SERVER_HOST_NAME, SERVER_PORT];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
#ifdef ENABLE_BASIC_AUTH
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:BASIC_AUTH_USER password:BASIC_AUTH_PASS];
#endif
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:zipData name:@"file" fileName:zipName mimeType:@"application/zip"];
    } success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"[SUCCESS] %@", response);
        [SVProgressHUD dismiss];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[ERROR]:  %@", [error description]);
        [SVProgressHUD dismiss];
    }];
}

- (IBAction)touchExitButton:(id)sender
{
    if (![self validateFilterName]) return;
    [self saveFilterContents];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)touchUploadButton:(id)sender
{
    if (![self validateFilterName]) return;
    [self saveFilterContents];
    [self uploadFilter];
}

@end
