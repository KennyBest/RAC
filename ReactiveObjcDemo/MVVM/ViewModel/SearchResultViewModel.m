//
//  SearchResultViewModel.m
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/21.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import "SearchResultViewModel.h"

@implementation SearchResultViewModel

- (instancetype)initWithSearchResults:(BXGoodsSearchResults *)results services:(id<ViewModelServices>)services {
    if (self = [super init]) {
        _title = results.searchString;
        _searchResults = results.goods;
    }
    return self;
}

@end
