//
//  FilterDataManager.h
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/10/02.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilterData.h"

@interface FilterDataManager : NSObject

/* CREATE/UPDATE */
- (void)saveFilterDataWithName:(NSString *)filterName withInputImagePath:(NSString *)inputImagePath withData:(NSDictionary *)filterData;

/* READ */
- (FilterData *)getFilterDataWithName:(NSString *)filterName;
- (NSMutableDictionary *)allDictionaryFilterData;
- (NSArray *)allArrayFilterData;

/* DELETE */
- (BOOL)deleteFilterWithName:(NSString *)filterName;
- (void)deleteAllFilter;

@end
