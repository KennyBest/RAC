//
//  FlickrSearchViewModel.m
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/20.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import "FlickrSearchViewModel.h"
#import "BXGoodsSearchResults.h"

@interface FlickrSearchViewModel ()
@property (strong, nonatomic) RACSignal *searchCommondSignal;
@property (weak, nonatomic) id<ViewModelServices> services;
@end

@implementation FlickrSearchViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithServices:(id<ViewModelServices>)services {
    self = [super init];
    if (self) {
        _services = services;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.title = @"Flickr Search";
    
    RACSignal *vaildSignal = [[RACObserve(self, searchText)
                               map:^id _Nullable(id  _Nullable value) {
                                   NSString *text = value;
                                   return @(text.length > 3);
                               }]
                              distinctUntilChanged];
    [vaildSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"search text is valid %@", x);
    }];
    
    // 当vailSignal传递YES的时候commond才可用 signalBlock里面执行操作
    self.executeSearch = [[RACCommand alloc] initWithEnabled:vaildSignal
                                                 signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
                                                     return [self executeSearchSignal];
    }];
}

- (RACSignal *)executeSearchSignal {
    return [[[self.services getFlickrSearchService]
             flickrSearchSignal:self.searchText]
            doNext:^(id  _Nullable x) {
                NSLog(@"SearchViewModel---->\n%@", x);
                BXGoodsSearchResults *results = x;
                self.goods = results.goods;
            }];
}

@end
