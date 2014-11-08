//
//  FilterStorageViewController.m
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/24.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "FilterStorageViewController.h"
#import "EditFilterViewController.h"
#import "FilterDataManager.h"

@interface FilterStorageViewController ()

@property(nonatomic) NSArray *filters;

@end

@implementation FilterStorageViewController

static NSString *CELL_IDENTIFIER = @"FILTER_TABLE_CELL";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundThemeColor];
    [self.filterListView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.filters = [[[FilterDataManager alloc] init] allArrayFilterData];
    [self.filterListView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filters count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    FilterData *filter     = self.filters[indexPath.row];
    cell.textLabel.text    = filter.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterData *filter = self.filters[indexPath.row];
    EditFilterViewController *editFilterVC = [[EditFilterViewController alloc] initWithNibName:@"EditFilterViewController" bundle:nil];
    editFilterVC.baseImagePath  = filter.inputImagePath;
    editFilterVC.baseImage      = filter.inputImage;
    editFilterVC.filterContents = [filter.body mutableCopy];
    editFilterVC.filterName     = filter.name;
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:editFilterVC];
    [self presentViewController:naviVC animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        FilterData *filter = self.filters[indexPath.row];
        FilterDataManager *filterDataManager = [[FilterDataManager alloc] init];
        [filterDataManager deleteFilterWithName:filter.name];
        self.filters = [filterDataManager allArrayFilterData];
        [self.filterListView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (IBAction)touchCreateNewFilterButton:(id)sender
{
    EditFilterViewController *editFilterVC = [[EditFilterViewController alloc] initWithNibName:@"EditFilterViewController" bundle:nil];
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:editFilterVC];
    [self presentViewController:naviVC animated:YES completion:nil];
}

@end
