//
//  BXGoods.h
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/21.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXGoods : NSObject

@property (copy, nonatomic) NSString *GoodsId;
@property (copy, nonatomic) NSString *GoodsName;
@property (copy, nonatomic) NSString *SeoCode;
@property (copy, nonatomic) NSString *GoodsImg;
@property (copy, nonatomic) NSString *GoodsTryModel;
@property (assign, nonatomic) float Price;
@property (copy, nonatomic) NSString *FavoritesId;
@property (assign, nonatomic) BOOL IsFavoritesId;
@property (assign, nonatomic) float MarketPrice;
@property (assign, nonatomic) NSInteger RemarkCount;
@property (assign, nonatomic) NSInteger SaleQuantity;

@end
