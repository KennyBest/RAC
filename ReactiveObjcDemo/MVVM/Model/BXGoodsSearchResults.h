//
//  BXGoodsSearchResults.h
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/21.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXGoodsSearchResults : NSObject

@property (strong, nonatomic) NSString *searchString;
@property (strong, nonatomic) NSArray *goods;
@property (assign, nonatomic) NSInteger totalResults;

@end
