//
//  FlickrSearch.h
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/20.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

@protocol FlickrSearch<NSObject>
- (RACSignal *)flickrSearchSignal:(NSString *)searchString;
@end
