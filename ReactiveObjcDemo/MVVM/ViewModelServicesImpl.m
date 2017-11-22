//
//  ViewModelServicesImpl.m
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/20.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import "ViewModelServicesImpl.h"
#import "FlickrSearchImpl.h"

@interface ViewModelServicesImpl ()

@property (strong, nonatomic) FlickrSearchImpl *searchService;
@end

@implementation ViewModelServicesImpl

- (instancetype)init {
    if (self = [super init]) {
        _searchService = [[FlickrSearchImpl alloc] init];
    }
    return self;
}

- (id<FlickrSearch>)getFlickrSearchService {
    return self.searchService;
}

- (void)pushViewModel:(id)viewModel {
    
}
@end
