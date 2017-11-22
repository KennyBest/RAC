//
//  SearchResultViewModel.h
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/21.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ViewModelServices.h"
#import "BXGoodsSearchResults.h"

@interface SearchResultViewModel : NSObject

- (instancetype)initWithSearchResults:(BXGoodsSearchResults *)results services:(id<ViewModelServices>)services;

@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *searchResults;

@end
