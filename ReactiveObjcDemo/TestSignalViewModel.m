//
//  TestSignalViewModel.m
//  ReactiveObjcDemo
//
//  Created by kede on 2017/11/15.
//  Copyright © 2017年 AJIAO. All rights reserved.
//

#import "TestSignalViewModel.h"

@interface TestSignalViewModel ()

@property (strong, nonatomic) RACSignal *subjectSignal;

@end

@implementation TestSignalViewModel

- (RACSignal *)changeColorSignal {
    if (!_changeColorSignal) {
        __weak typeof(self) weakSelf = self;
        _changeColorSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            weakSelf.view.backgroundColor = [UIColor redColor];
            [subscriber sendCompleted];
            return nil;
        }];
    }
    return _changeColorSignal;
}

- (RACSubject *)changeColorSubject {
    if (!_changeColorSubject) {
        _changeColorSubject = [RACSubject subject];
        RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:_changeColorSubject];
            [subscriber sendCompleted];
            return nil;
        }];
        self.subjectSignal = [signal flatten];
        [self.subjectSignal subscribeNext:^(id  _Nullable x) {
            self.view.backgroundColor = (UIColor *)x;
        }];
    }
    return _changeColorSubject;
}
@end
