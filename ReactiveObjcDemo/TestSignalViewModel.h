//
//  TestSignalViewModel.h
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/15.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestSignalView.h"
#import "ReactiveObjC.h"

@interface TestSignalViewModel : NSObject

@property (strong, nonatomic) TestSignalView *view;

@property (strong, nonatomic) RACSignal *changeColorSignal;

@property (strong, nonatomic) RACSubject *changeColorSubject;
@end
