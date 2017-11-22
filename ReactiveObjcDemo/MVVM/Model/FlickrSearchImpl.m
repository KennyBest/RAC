//
//  FlickrSearchImpl.m
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/20.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import "FlickrSearchImpl.h"
#import "BXGoods.h"
#import "BXGoodsSearchResults.h"

#import <objectiveflickr/ObjectiveFlickr.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>

@interface FlickrSearchImpl () <OFFlickrAPIRequestDelegate>

@property (strong, nonatomic) NSMutableSet *requests;
@property (strong, nonatomic) OFFlickrAPIContext *flickrContext;

@end

@implementation FlickrSearchImpl

- (instancetype)init {
    self = [super init];
    if (self) {
        _requests = [[NSMutableSet alloc] init];
    }
    return self;
}

- (RACSignal *)flickrSearchSignal:(NSString *)searchString {
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *path = @"http://192.168.117.146:4001/api/Goods/Search?Sort=0&KeyWord=%E5%8D%9A%E5%A3%AB%E4%BC%A6&Size=10&Page=1";
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
        [request setValue:@"0ab674990c594e6dadec45a3a260a8a1" forHTTPHeaderField:@"Token"];
        [request setValue:@"722F6A98-E091-4432-8877-78D926EEBDF6" forHTTPHeaderField:@"salePlatformId"];
        request.HTTPMethod = @"POST";
        
        NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                [subscriber sendError:error];
            }
            NSError *jsonError;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if (!jsonError) {
                BXGoodsSearchResults *results = [[BXGoodsSearchResults alloc] init];
                results.searchString = searchString;
                NSArray *array = dictionary[@"Data"];
                results.goods = [array linq_select:^id(NSDictionary *item) {
                    BXGoods *goods = [[BXGoods alloc] init];
                    goods.GoodsName = item[@"GoodsName"];
                    goods.GoodsImg = item[@"GoodsImg"];
                    return goods;
                }];
                [subscriber sendNext:results];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:jsonError];
            }
        }];
        [task resume];
        return nil;
    }];
    
}

@end
