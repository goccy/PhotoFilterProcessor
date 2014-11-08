//
//  FilterStorageViewController.h
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/24.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterStorageViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) IBOutlet UITableView *filterListView;

@end
