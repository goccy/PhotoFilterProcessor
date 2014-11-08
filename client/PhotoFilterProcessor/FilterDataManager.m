//
//  FilterDataManager.m
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/10/02.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "FilterDataManager.h"

@implementation FilterDataManager

static NSString *FILTER_DATA_KEY = @"FILTER_DATA";

- (NSMutableDictionary *)allDictionaryFilterRawData
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *allFilterData = [[userDefault dictionaryForKey:FILTER_DATA_KEY] mutableCopy];
    return (allFilterData) ? allFilterData : [@{} mutableCopy];
}

- (NSMutableDictionary *)allDictionaryFilterData
{
    NSMutableDictionary *allFilterData = [self allDictionaryFilterRawData];
    for (NSString *filterName in [allFilterData allKeys]) {
        allFilterData[filterName] = [self getFilterDataWithDictionary:allFilterData[filterName]];
    }
    return (allFilterData) ? allFilterData : [@{} mutableCopy];
}

- (NSArray *)allArrayFilterData
{
    NSMutableArray *filters = [[NSMutableArray alloc] init];
    NSMutableDictionary *allFilterData = [self allDictionaryFilterRawData];
    for (NSString *filterName in [allFilterData allKeys]) {
        [filters addObject:[self getFilterDataWithName:filterName]];
    }
    [filters sortUsingComparator:^NSComparisonResult(FilterData *dataA, FilterData *dataB) {
        return [dataB.updatedAt compare:dataA.updatedAt];
    }];
    return (filters) ? filters : @[];
}

- (void)saveAllFilterData:(NSMutableDictionary *)allFilterData
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:allFilterData forKey:FILTER_DATA_KEY];
    [userDefault synchronize];
}

- (void)saveFilterDataWithName:(NSString *)filterName withInputImagePath:(NSString *)inputImagePath withData:(NSDictionary *)filterData
{
    NSMutableDictionary *allFilterData = [self allDictionaryFilterRawData];
    NSNumber *currentDate = @([[NSDate date] timeIntervalSince1970]);
    NSMutableDictionary *existsFilterData = [allFilterData[filterName] mutableCopy];
    NSMutableDictionary *data = [@{
        @"name"           : filterName,
        @"inputImagePath" : inputImagePath,
        @"body"           : filterData,
        @"updatedAt"      : currentDate
    } mutableCopy];
    if (!existsFilterData) {
        data[@"createdAt"] = currentDate;
    } else {
        data[@"createdAt"] = existsFilterData[@"createdAt"];
    }
    allFilterData[filterName] = data;
    [self saveAllFilterData:allFilterData];
}

- (FilterData *)getFilterDataWithDictionary:(NSDictionary *)data
{
    FilterData *filterData    = [[FilterData alloc] init];
    filterData.name           = data[@"name"];
    filterData.inputImagePath = data[@"inputImagePath"];
    filterData.body           = data[@"body"];
    filterData.updatedAt      = [NSDate dateWithTimeIntervalSince1970:[data[@"updatedAt"] integerValue]];
    filterData.createdAt      = [NSDate dateWithTimeIntervalSince1970:[data[@"createdAt"] integerValue]];
    return filterData;
}

- (FilterData *)getFilterDataWithName:(NSString *)filterName
{
    NSMutableDictionary *allFilterData = [self allDictionaryFilterRawData];
    return [self getFilterDataWithDictionary:allFilterData[filterName]];
}

- (BOOL)deleteFilterWithName:(NSString *)filterName
{
    NSMutableDictionary *allFilterData = [self allDictionaryFilterRawData];
    [allFilterData removeObjectForKey:filterName];
    [self saveAllFilterData:allFilterData];
    return (![self getFilterDataWithName:filterName]) ? YES : NO;
}

- (void)deleteAllFilter
{
    [self saveAllFilterData:[[NSMutableDictionary alloc] init]];
}

@end
