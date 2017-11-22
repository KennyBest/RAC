//
//  FlickrSearchResults.h
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/20.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrSearchResults : NSObject

@property (strong, nonatomic) NSString *searchString;
@property (strong, nonatomic) NSArray *photos;
@property (assign, nonatomic) NSUInteger totalResults;

@end
