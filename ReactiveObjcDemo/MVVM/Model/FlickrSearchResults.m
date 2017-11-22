//
//  FlickrSearchResults.m
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/20.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import "FlickrSearchResults.h"

@implementation FlickrSearchResults

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ -- %@ -- %lu", self.searchString, self.photos, self.totalResults];
}

@end
