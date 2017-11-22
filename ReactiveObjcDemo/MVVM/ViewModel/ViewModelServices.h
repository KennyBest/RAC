//
//  ViewModelServices.h
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/20.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FlickrSearch.h"

@protocol ViewModelServices <NSObject>
- (id<FlickrSearch>)getFlickrSearchService;
- (void)pushViewModel:(id)viewModel;
@end
