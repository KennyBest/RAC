//
//  FlickrSearchViewModel.h
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/20.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"
#import "ViewModelServices.h"

@interface FlickrSearchViewModel : NSObject

@property (strong, nonatomic) NSString *searchText;
@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) RACCommand *executeSearch;

- (instancetype)initWithServices:(id<ViewModelServices>)services;

@property (strong, nonatomic) NSArray *goods;
@end

/**
 The relationships between the three components of the MVVM pattern are simpler than the MVC equivalents, following these strict rules:
 The View has a reference to the ViewModel, but not vice-versa.
 The ViewModel has a reference to the Model, but not vice-versa.
 If you break either of these rules, you’re doing MVVM wrong!
 */
