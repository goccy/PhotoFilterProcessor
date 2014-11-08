//
//  UploadViewController.h
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/09/29.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) IBOutlet UIButton *uploadButton;
@property(nonatomic, weak) IBOutlet UIButton *exitButton;
@property(nonatomic, weak) IBOutlet UITextField *inputFilterNameField;
@property(nonatomic, weak) IBOutlet UITableView *usedFilterListView;

@property(nonatomic) NSArray *usedFilterNames;
@property(nonatomic) NSString *filterName;
@property(nonatomic) NSString *inputImagePath;
@property(nonatomic) UIImage *filteredImage;
@property(nonatomic) NSMutableDictionary *filterContents;

@end
